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
}