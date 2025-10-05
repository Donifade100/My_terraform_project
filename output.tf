output "aws_ami_id" {
    value = data.aws_ami.latest-al2023-linux-image.id
}

output "ec2_pubic_ip" {
    value = aws_instance.mola-server.public_ip
}