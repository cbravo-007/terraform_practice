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
  vpc_id = "${aws_vpc.default.id}"
}

# Grant access to VPC
resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.default.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.default.id}"
}

# Create a public subnet to launch our instances into
resource "aws_subnet" "webpublic" {
  vpc_id                  = "${aws_vpc.default.id}"
  cidr_block              = "${var.aws_cidr_public_subnet}"
  map_public_ip_on_launch = true
}

# Create a private subnet to launch our instances into
resource "aws_subnet" "appdbprivate" {
  vpc_id                  = "${aws_vpc.default.id}"
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
resource "aws_security_group" "web" {
  name        = "sec_group_web"
  description = "Security Group for Web tier"
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
  name = "Load Balancer for Web tier"
  subnets         = ["${aws_subnet.webpublic.id}"]
  security_groups = ["${aws_security_group.lba.id}"]
#  instances       = ["${aws_instance.web.id}"]
  listener {
    instance_port     = 8080
    instance_protocol = "http"
    lb_port           = 8080
    lb_protocol       = "http"
  }
}

resource "aws_launch_configuration" "basicConfiguration" {
  image_id = "ami-2d39803a"
  instance_type = "t2.micro"
  security_groups = ["${aws_security_group.web.id}"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "auto_scaling_web" {
  launch_configuration = "${aws_launch_configuration.basicConfiguration.id}"
  min_size = 2
  max_size = 10
  tag {
    key = "Name"
    value = "auto_scaling_web"
    propagate_at_launch = true
  }
}

resource "aws_instance" "app_tier" {
  ami = "ami-2d39803a"
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
