provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region["region1"]}"
}

# Create Pr0xy vpc
resource "aws_vpc" "pr0xy-vpc" {
  cidr_block           = "172.17.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags {
    Name  = "pr0xy-vpc"
    Usage = "This NOT is for my pr0xy"
  }
}

# Create Internet GateWay to get outside world
resource "aws_internet_gateway" "pr0xy-gw" {
  vpc_id = "${aws_vpc.pr0xy-vpc.id}"

  tags {
    Name  = "My Pr0xy Gateway"
    Usage = "Used for Pr0xy get out of the world"
  }
}

# Route table for VPC
resource "aws_route_table" "pr0xy-rt" {
  vpc_id = "${aws_vpc.pr0xy-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.pr0xy-gw.id}"
  }

  tags {
    Name = "Pr0xy Route table"
  }
}

# Assicate the VPC and RouteTable
resource "aws_main_route_table_association" "pr0xy-link" {
  vpc_id         = "${aws_vpc.pr0xy-vpc.id}"
  route_table_id = "${aws_route_table.pr0xy-rt.id}"
}

# Create Subnet for Pr0xy
resource "aws_subnet" "pr0xy-subnet" {
  cidr_block        = "${cidrsubnet(aws_vpc.pr0xy-vpc.cidr_block, 3, 1)}"
  vpc_id            = "${aws_vpc.pr0xy-vpc.id}"
  availability_zone = "${var.availability_zone["az3"]}"
}

resource "aws_security_group" "pr0xy-sg01" {
  vpc_id      = "${aws_vpc.pr0xy-vpc.id}"
  name        = "Allow_OpenSSH"
  description = "Allow OpenSSH inbound traffic"

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name  = "Open SSH port to the world"
    Usage = "Allow the SSH port to be accessed"
  }
}

data "template_file" "pr0xy-userdata" {
  template = "${file("${path.module}/files/myproxy.init.yml")}"
}

# Create EC2 instance for Pr0xy
resource "aws_instance" "pr0xy" {
  # myproxy
  ami = "${data.aws_ami.myami.id}"

  #ami = "ami-28e07e50"
  availability_zone           = "${var.availability_zone["az3"]}"
  associate_public_ip_address = "${var.associate_public_ip_address}"

  key_name               = "${var.key_name}"
  subnet_id              = "${aws_subnet.pr0xy-subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.pr0xy-sg01.id}"]
  instance_type          = "t2.micro"
  user_data              = "${data.template_file.pr0xy-userdata.rendered}"

  tags {
    Date   = "2018-11"
    Usage  = "Yep, this is not for Pr0xy"
    Expire = "2019-10"
  }
}

# Get latest RHEL-7 AMI for my pr0xy
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

# Update/Create DNS record in cloudflare for proxy server
provider "cloudflare" {
  email = "${var.cloudflare_email}"
  token = "${var.cloudflare_token}"
}

# Create a record
resource "cloudflare_record" "pr0xy" {
  domain = "${var.cloudflare_zone}"

  # yjij = youjumpijump
  name  = "yjij"
  value = "${aws_instance.pr0xy.public_ip}"
  type  = "A"
  ttl   = 120
}

output "result" {
  value = "Your pr0xy is ready for use : ${cloudflare_record.pr0xy.name}.${cloudflare_record.pr0xy.domain}"
}
