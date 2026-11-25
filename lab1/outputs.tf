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