variable "name" {
  description = "Nom de l'instance EC2 et préfixe des ressources associées"
  type        = string
  default     = "lab3"
}

variable "instance_type" {
  description = "Type d'instance EC2 (ex. t3.micro)"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "ID du sous-réseau à récupérer via la data source aws_subnet"
  type        = string
  default     = "subnet-0855fbfcf29f845c3"
}

variable "vpc_id" {
  description = "ID du VPC existant dans lequel créer le Security Group"
  type        = string
  default     = "vpc-01b6138c71cc82aba"
}

variable "public_key_path" {
  description = "Chemin vers la clé publique SSH locale"
  type        = string
  default     = "~/.ssh/terraform-lab-key.pub"
}

variable "ssh_cidr_blocks" {
  description = "Blocs CIDR autorisés sur le port 22 (SSH)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}