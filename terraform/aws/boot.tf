provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region["region1"]}"
}

resource "aws_vpc" "learn-terraform" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name  = "terraform-aws-learning"
    Usage = "This is test state file"
    Tag3  = "This is another test"
  }
}

resource "aws_subnet" "subnet1" {
  cidr_block        = "${cidrsubnet(aws_vpc.learn-terraform.cidr_block, 3, 1)}"
  vpc_id            = "${aws_vpc.learn-terraform.id}"
  availability_zone = "us-west-2a"
}

resource "aws_subnet" "subnet2" {
  cidr_block        = "${cidrsubnet(aws_vpc.learn-terraform.cidr_block, 2, 2)}"
  vpc_id            = "${aws_vpc.learn-terraform.id}"
  availability_zone = "us-west-2b"
}

resource "aws_security_group" "subnetsec" {
  vpc_id = "${aws_vpc.learn-terraform.id}"

  ingress {
    cidr_blocks = [
      "${aws_vpc.learn-terraform.cidr_block}",
    ]

    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }
}

data "template_file" "proxy-userdata" {
  template = "${file("${path.module}/files/myproxy.init.yml")}"
}

resource "aws_instance" "myproxy" {
  # myproxy
  ami = "${data.aws_ami.myami.id}"

  #ami = "ami-28e07e50"
  availability_zone           = "${var.availability_zone["az3"]}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  key_name               = "${var.key_name}"
  subnet_id              = "${var.subnet_id}"
  vpc_security_group_ids = "${var.vpc_security_group_ids}"
  instance_type          = "t2.micro"
  user_data              = "${data.template_file.proxy-userdata.rendered}"

  tags {
    Date   = "2018-11"
    Usage  = "myproxy"
    Expire = "2019-10"
  }
}

data "aws_ami" "myami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["309956199498"]
}

output "ami_id" {
  value = "${data.aws_ami.myami.id}"
}

output "myproxy_ip" {
  value = "${aws_instance.myproxy.public_ip}"
}
