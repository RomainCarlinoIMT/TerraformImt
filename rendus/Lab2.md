# Lab 2

main.tf
```
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
```

| Note : j'ai créer le dossier lab2 qui importe mon module depuis github pour montrer que cela marche bien.

## Modifications sur le lab 1

main.tf
```
// provider "docker" {
//   host = "unix:///var/run/docker.sock"
// }

# Pulls the image
resource "docker_image" "app" {
  name = var.image_name
}

# Create a container
resource "docker_container" "balancer" {
  count = var.container_count

  image      = docker_image.app.image_id
  name       = "${var.name_prefix}-${count.index + 1}"
  hostname   = "${var.name_prefix}-${count.index + 1}"
  memory     = var.memory_mb > 0 ? var.memory_mb : null
  privileged = var.privileged

  ports {
    internal=80
    external=var.start_port + count.index
  }

  upload {
    file       = "/docker-entrypoint.d/99-set-hostname.sh"
    executable = true
    content    = <<-EOF
      #!/bin/sh
      echo "<h1>Hostname : $(hostname)</h1>" > /usr/share/nginx/html/index.html
    EOF
  }
}
```

main.tfvars
```
image_name      = "nginx:latest"
memory_mb       = 256
privileged      = false
container_count = 3
name_prefix     = "test"
start_port      = 8000
```

outputs.tf
```
output "endpoints" {
  description = "List of hostname and urls created"
  value = [
    for c in docker_container.balancer : {
      name     = c.name
      hostname = c.hostname
      url      = "http://localhost:${c.ports[0].external}"
    }
  ]
}
```

variables.tf
```
variable "image_name" {
    description = "Image name"
    type  = string
    default = "nginx:latest"
}

variable "memory_mb" {
    description = "memory limit"
    type =  number
    default = 0
}

variable "privileged" {
  description = "is container privileged"
  type        = bool
  default     = false
}

variable "container_count" {
    description = "Number of container to create"
    type = number
    default = 1
}

variable "name_prefix" {
    description = "Start of each name instance"
    type = string
    default = "nginx"
}

variable "start_port" {
    description = "first port for iteration"
    type = number
}
```

version.tf
```
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.7.0"
    }
  }
}
```