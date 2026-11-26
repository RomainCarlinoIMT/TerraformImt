output "public_ip" {
  description = "Adresse IP publique de l'instance EC2"
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "Nom DNS public de l'instance EC2"
  value       = aws_instance.this.public_dns
}