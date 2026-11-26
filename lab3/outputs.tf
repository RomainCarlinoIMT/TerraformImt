output "public_ip" {
  description = "Adresse IP publique de l'instance EC2"
  value       = module.ec2_vm.public_ip
}

output "public_dns" {
  description = "Nom DNS public de l'instance EC2"
  value       = module.ec2_vm.public_dns
}