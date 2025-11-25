terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

resource "docker_network" "web_network" {
  name = "web-network"
}

resource "docker_image" "postgres" {
  name         = "postgres:13"
  force_remove = true
}

resource "docker_container" "database" {
  image = docker_image.postgres.image_id
  name  = "postgres-db"

  env = [
    "POSTGRES_DB=myapp",
    "POSTGRES_USER=admin",
    "POSTGRES_PASSWORD=password123"
  ]

  ports {
    internal = 5432
    external = 5432
  }

  networks_advanced {
    name = docker_network.web_network.name
  }
}

resource "docker_image" "redis" {
  name         = "redis:alpine"
  force_remove = true
}

resource "docker_container" "cache" {
  image = docker_image.redis.image_id
  name  = "redis-cache"

  ports {
    internal = 6379
    external = 6379
  }

  networks_advanced {
    name = docker_network.web_network.name
  }
}


resource "docker_image" "webapp" {
  name         = "nginx:latest"
  force_remove = true
}

resource "docker_container" "web" {
  image = docker_image.webapp.image_id
  name  = "web-app"

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = docker_network.web_network.name
  }

  depends_on = [
    docker_container.database,
    docker_container.cache
  ]
}
