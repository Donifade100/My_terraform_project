resource "aws_default_security_group" "default_sg" {
    vpc_id = aws_vpc.mola-vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = [var.my_ip]
    }

    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
        prefix_list_ids = []
    }

    tags = {
        Name: "${var.env_prefix}-default-sg"
    }
}


data "aws_ami" "latest-al2023-linux-image" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-2023.*-kernel-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_key_pair" "mola-ssh-key" {
    key_name = "mola-server-key"
    public_key = file(var.public_key_location)
}

resource "aws_instance" "mola-server" {
    ami = data.aws_ami.latest-al2023-linux-image.id
    instance_type = var.instance_type

    subnet_id = module.mola-subnet.subnet.id
    vpc_security_group_ids = [aws_default_security_group.default_sg.id]
    availability_zone = var.avail_zone

    associate_public_ip_address = true
    key_name = aws_key_pair.mola-ssh-key.key_name

    user_data = file("entry-script.sh")
        
    user_data_replace_on_change = true

    # connection {
    #     type = "ssh"
    #     host = self.public_ip
    #     user = "ec2-user"
    #     private_key = file(var.private_key_location)
    # }

    # provisioner "file" {
    #     source = "entry-script.sh"
    #     destination = "/home/ec2-user/mola-server-entry-script.sh"
    # }

    # provisioner "remote-exec" {
    #     inline = ["/home/ec2-user/mola-server-entry-script.sh"]
    # }

    tags = {
        Name: "${var.env_prefix}-server"
    }
}