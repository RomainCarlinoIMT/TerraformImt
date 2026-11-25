terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 4.7"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

module "web_nodes" {
  source = "git::https://github.com/RomainCarlinoIMT/TerraformImt.git//lab1"

  image_name      = "nginx:latest"
  memory_mb       = 256
  privileged      = false
  container_count = 4
  name_prefix     = "jaaj"
  start_port      = 8000
}

output "endpoints" {
  value = module.web_nodes.endpoints
}