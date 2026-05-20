# Base Docker Web Project with IaC & CI/CD Validation

A local, production-grade DevOps sandbox environment built entirely inside native **WSL 2 (Ubuntu)**. This repository tracks the evolution of a containerized application from manual execution to multi-container orchestration, programmatic state management with Infrastructure as Code (IaC), and automated cloud testing using continuous integration.

## 🏗️ Architectural Evolution

The project was developed across three distinct engineering milestones to demonstrate core containerization and lifecycle automation concepts:

1. **Bare-Metal Containerization (Docker Engine):** Deployed a custom static Nginx web server using native Linux daemons (`docker-ce`), isolating web traffic to container ports.
2. **Infrastructure as Code (Terraform):** Shifted infrastructure management from imperative CLI commands to declarative configuration scripts (`main.tf`), programmatically handling the container runtime state.
3. **Continuous Integration (GitHub Actions):** Implemented an automated cloud pipeline to catch syntax errors, dead layers, or security vulnerabilities in container blueprints prior to deployment.

---

## 🛠️ Step-by-Step Implementation Guide

### Milestone 1: App Creation & Local Container Routing
Set up the application layer and map inbound host traffic down to the virtualized application runtime.

1. **Draft the Application Landing Page:**
   ```bash
   cat << 'EOF' > index.html
   <!DOCTYPE html>
   <html>
   <head><title>Base Docker Web</title></head>
   <body style="background:#121212; color:#fff; font-family:sans-serif; text-align:center; padding-top:20vh;">
       <h1 style="color:#00ffcc;">Docker Engine Container Live</h1>
       <p>Built natively inside WSL 2 Ubuntu.</p>
   </body>
   </html>
   EOF# 


