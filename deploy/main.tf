## Template for ctest

# Configure the AWS Provider
provider "aws" {
     access_key = "${var.access_key}"
     secret_key = "${var.secret_key}"
     region = "ap-southeast-2"
}

# ssh key resource
resource "aws_key_pair" "ssh-key" {
   key_name   = "ssh-key"
   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCygZajRGaIZn15VXBDDpIgAWg3lwc2EKgWkg38MhYNWiqAUVlogosPd9WNvLn0De847ryqrrsH/4f41rH47RlBE4if5O6RPfmJX8kuUCezwsl+USzYYQqSIwvwRke2QgR4oHKU6VyrtRw+hnL95U+njlSfuQ8kyQRIPlc0e8wSElZZkjEKn3LUgTXKRkKCUSrpYGn1eamk/CERlAxcKHYK/DiYbfzi9L7C1nJz3j2uJlD41AgLiDptxu1AI3viTAj56PiXHJr8ykSuz5W7qY68rJ6MObRzyA87t1wh3QwfnZDMVDPRuAblNHCXRmScAngHzRk+vIrb0ARmv1sSAVcL binod@192-168-1-6.tpgi.com.au"
 }

data "aws_ami" "centos7" {
  most_recent = true
  owners = ["679593333241"]

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS 1708_11.01-b7ee8a69-ee97-4a49-9e68-afaee216db2e-ami-95096eef.4"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# External security group
resource "aws_security_group" "external" {
  name        = "external"
  description = "Allow all inbound traffic"
  vpc_id      = "${var.vpc_id}"

 ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      self      = "true"
    }
 egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["${var.vpc_cidr}"]
    }

  tags {
    Name = "external_allow_all"
  }
}

# Internal App security group
resource "aws_security_group" "internal" {
  name        = "internal"
  description = "Allow inbound traffic from external security group"
  vpc_id      = "${var.vpc_id}"

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    security_groups = ["${aws_security_group.external.id}"] 
  }
  egress {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      self      = "true"
    }

  tags {
    Name = "internal"
  }
}

# App load balancer
resource "aws_elb" "app-elb" {
  name = "app-elb"
  security_groups = ["${aws_security_group.external.id}"]
  subnets = "${var.subnet}"
  internal = "false"

  listener {
    instance_port = 5000
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }
 listener {
    instance_port = 5000
    instance_protocol = "http"
    lb_port = 5000
    lb_protocol = "http"
  }

 health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 30
    target = "TCP:5000"
    interval = 60
  }

  tags {
    Name = "app-elb"
  }
  provisioner "local-exec" { 
  command = "echo ${aws_elb.app-elb.dns_name} >> elb_dns.txt" 
 }
  provisioner "local-exec" {
  command = "echo ${aws_elb.app-elb.name} >> elb_dns.txt"
 }
}

# Instance Userdate
 data "template_file" "script" {
   template = "${file("${path.module}/init.tpl")}"

}

# cloud init
 data "template_cloudinit_config" "config" {
   gzip          = true
   base64_encode = true

  part {
    filename     = "init.cfg"
    content_type = "text/part-handler"
    content      = "${data.template_file.script.rendered}"
  }

}


# App launch configuration
 resource "aws_launch_configuration" "flask-app" {
    name = "flask-app"
    image_id = "${data.aws_ami.centos7.id}"
    instance_type = "${var.app_instance_type}"
    #key_name = "${var.ssh_key}"
    key_name = "${aws_key_pair.ssh-key.key_name}"
    security_groups = ["${aws_security_group.internal.id}"]
    associate_public_ip_address = "true"
    user_data  = "${data.template_cloudinit_config.config.rendered}"
    lifecycle {
      create_before_destroy = true
    }

   root_block_device {
        volume_type = "gp2"
        volume_size = "10"
    }
}

## Autoscaling Group Configuration Nginx
 resource "aws_autoscaling_group" "flask-app" {
  availability_zones = "${var.zones}"
  vpc_zone_identifier = "${var.subnet}"
  name = "flask-app"
  max_size = "${var.max_num}"
  min_size = "${var.min_num}"
  health_check_grace_period = 300
  health_check_type = "ELB"
  desired_capacity = "${var.desired_num}"
  force_delete = true
  termination_policies = ["OldestInstance"]
  launch_configuration = "${aws_launch_configuration.flask-app.name}"
  load_balancers = ["${aws_elb.app-elb.name}"]
}


