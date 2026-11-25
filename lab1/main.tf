

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
