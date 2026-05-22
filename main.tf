terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# Variable configuration to protect your secret tunnel token
variable "cloudflare_tunnel_token" {
  type        = string
  description = "The secure tunnel token from your Cloudflare Zero Trust dashboard"
  sensitive   = true
}

# 1. Private Network Bridge
resource "docker_network" "private_network" {
  name = "app-public-edge-net"
}

# 2. Database Layer (PostgreSQL) with Schema Initialization
resource "docker_container" "db_container" {
  name  = "db"
  image = "postgres:15-alpine"
  networks_advanced { name = docker_network.private_network.name }
  env = [
    "POSTGRES_USER=postgres",
    "POSTGRES_PASSWORD=password",
    "POSTGRES_DB=postgres"
  ]

  # Mounts your local init.sql into the container's automatic startup folder
  volumes {
    host_path      = "${path.cwd}/init.sql"
    container_path = "/docker-entrypoint-initdb.d/init.sql"
  }
}

# 3. Application Image & Container Build
resource "docker_image" "app_image" {
  name = "local-flask-app:latest"
  build {
    context    = "."
    dockerfile = "Dockerfile"
  }
}

resource "docker_container" "app_container" {
  name  = "devops-mission-control-app"
  image = docker_image.app_image.image_id
  networks_advanced { name = docker_network.private_network.name }
  
  # No external ports mapped to host. Completely protected from raw scanning.
  depends_on = [docker_container.db_container]
}

# 4. Cloudflare Edge Tunnel Layer
resource "docker_container" "cloudflare_tunnel" {
  name  = "cloudflare-tunnel"
  image = "cloudflare/cloudflared:latest"
  networks_advanced { name = docker_network.private_network.name }
  
  command    = ["tunnel", "--no-autoupdate", "run", "--token", var.cloudflare_tunnel_token]
  restart    = "always"
  depends_on = [docker_container.app_container]
}
