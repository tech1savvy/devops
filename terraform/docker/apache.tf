terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_image" "apache" {
  name         = "httpd:latest"
  force_remove = true
}

resource "docker_container" "apache" {
  image = docker_image.apache.image_id
  name  = "apache-server"

  ports {
    internal = 80
    external = 8080
  }

  restart = "always"
}
