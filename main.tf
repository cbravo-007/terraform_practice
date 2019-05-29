# Select Provider AWS
provider "aws" {
  region = "${var.aws_region}"
}

# Create a custom VPM for the practice
resource "aws_vpc" "customVPC" {
  cidr_block = "${var.aws_cidr_vpc}"
}

# Create a custom Internet Gateway
resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.customVPC.id}"
}

# Grant access to VPC
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.customVPC.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Creation of default subnet
resource "aws_default_subnet" "default-east-1" {
  availability_zone = "us-east-1"

  tags = {
    Name = "Default subnet for us-east-1"
  }
}

# Create a public subnet to launch our instances into
resource "aws_subnet" "webpublic" {
  vpc_id                  = "${aws_vpc.customVPC.id}"
  cidr_block              = "${var.aws_cidr_public_subnet}"
  map_public_ip_on_launch = true
}

resource "aws_default_subnet" "webpublic" {
  availability_zone = "us-east-1"

  tags = {
    Name = "Default subnet for us-east-1"
  }
}


# Create a private subnet to launch our instances into
resource "aws_subnet" "appdbprivate" {
  vpc_id                  = "${aws_vpc.customVPC.id}"
  cidr_block              = "${var.aws_cidr_private_subnet}"
  map_public_ip_on_launch = true
}

# Security group for Load Balancer
resource "aws_security_group" "lba" {
  name        = "load_balancer_webtier"
  description = "Load Balancer for Web Tier"
  vpc_id      = "${aws_vpc.customVPC.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Web tier. Port 22 and 8080 open
resource "aws_security_group" "web" {
  name        = "sec_group_web"
  description = "Security Group for Web tier"
  vpc_id      = "${aws_vpc.customVPC.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for Web tier. Port 22 and 9043 open
resource "aws_security_group" "app" {
  name        = "sec_group_app"
  description = "Security Group for App tier"
  vpc_id      = "${aws_vpc.customVPC.id}"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.aws_cidr_vpc}"]
  }
  ingress {
    from_port   = 9043
    to_port     = 9043
    protocol    = "tcp"
    cidr_blocks = ["${var.aws_cidr_vpc}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for DB tier. Port 9043 open
resource "aws_security_group" "db" {
  name        = "sec_group_db"
  description = "Security Group for DB tier"
  vpc_id      = "${aws_vpc.customVPC.id}"
  ingress {
    from_port   = 9043
    to_port     = 9043
    protocol    = "tcp"
    cidr_blocks = ["${var.aws_cidr_vpc}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elb" "web" {
  name = "loadBalancerWebTier"
  subnets         = ["${aws_subnet.webpublic.id}"]
  security_groups = ["${aws_security_group.lba.id}"]
  instances       = ["${aws_instance.app_tier.id}","${aws_instance.rds_instance.id}"]
  listener {
    instance_port     = "${var.aws_listener_port}"
    instance_protocol = "http"
    lb_port           = "${var.aws_listener_port}"
    lb_protocol       = "http"
  }
}

resource "aws_instance" "app_tier" {
  ami = "${var.aws_ami_instance}"
  instance_type = "t2.micro"
  user_data = <<-EOF
            #!/bin/bash
            echo "Hello World, App tier!!" > index.html
            nohup busybox httpd -f -p 8080 &
            EOF

  tags = {
    Name = "EC2 Instance - App tier"
  }
}

resource "aws_instance" "rds_instance" {
  ami = "${var.aws_ami_instance}"
  instance_type = "t2.micro"
  user_data = <<-EOF
            #!/bin/bash
            echo "Hello World, RDS Instance!!" > index.html
            nohup busybox httpd -f -p 8080 &
            EOF

  tags = {
    Name = "EC2 Instance - RDS Instance"
  }
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = "${aws_rds_cluster.default.id}"
  instance_class     = "db.r4.large"
}

resource "aws_rds_cluster" "default" {
  cluster_identifier = "aurora-cluster-demo"
  availability_zones = ["${var.aws_availability_zone}"]
  database_name      = "mydb"
  master_username    = "foo"
  master_password    = "barbut8chars"
}
