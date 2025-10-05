output "ec2_pubic_ip" {
    value = module.mola-app-server.instance.public_ip
}