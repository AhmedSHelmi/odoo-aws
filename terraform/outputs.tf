output "instance_public_ip" {
  value = aws_instance.odoo_instance.public_ip
}
