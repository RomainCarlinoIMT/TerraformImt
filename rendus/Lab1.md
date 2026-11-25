# Lab 1

```
terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.7.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Pulls the image
resource "docker_image" "nginx" {
  name = "nginx:latest"
}

# Create a container
resource "docker_container" "balancer" {
  image = docker_image.nginx.image_id
  name  = "balancer"
  hostname = "nginx_test"
  ports {
    internal=80
    external=8000
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

upload et hostname sont pour le bonus 1