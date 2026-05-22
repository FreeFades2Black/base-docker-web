### Last Updated: 2026-05-20 13:52:17
### Last Sync: 2026-05-20 13:52:27
### Last Sync: 2026-05-20 14:01:31
### Last Sync: 2026-05-20 14:21:09
### Last Sync: 2026-05-20 18:26:32
### Last Sync: 2026-05-20 19:06:39
### Last Sync: 2026-05-20 19:13:07
### Last Sync: 2026-05-20 19:29:11
# Public Edge Deployment via WSL 2

## 1. Edit the Terraform Configuration
nano main.tf
# (Paste the new configuration code, hit Ctrl+O, Enter to save, Ctrl+X to exit)

## 2. Initialize the Workspace
# Run this if you need to fetch the updated Docker provider schema
terraform init

## 3. Run the Infrastructure Deployment
# Replace the placeholder below with your token from Cloudflare Zero Trust
terraform apply -var="cloudflare_tunnel_token=YOUR_CLOUDFLARE_TUNNEL_TOKEN" -auto-approve

## 4. Verify Live Containers
docker ps


# Pre-Flight Configuration Check

## 1. Validate the Terraform Syntax
# This checks your code files for structural correctness without building anything
terraform validate

## 2. Test Run (Dry Run)
# This will show you exactly what it plans to build. 
# It will prompt you to type a value for the token—just press Enter or type 'test' to verify it passes.
terraform plan




# Final Public Edge Deployment Steps

## 1. Retrieve Your Cloudflare Token
# Log into your Cloudflare Zero Trust Dashboard -> Networks -> Tunnels
# Copy the alphanumeric string following the '--token' flag in the Docker tab

## 2. Execute Live Deployment
# Run this command inside ~/base-docker-web (replace the placeholder with your actual token)
terraform apply -var="cloudflare_tunnel_token=YOUR_ACTUAL_CLOUDFLARE_TOKEN" -auto-approve

## 3. Verify System Operations
# Check that all three containers (db, app, tunnel) show an 'Up' status
docker ps

## 4. Check the Live Public URL
# Open your browser and navigate to your configured domain (e.g., https://app.yourdomain.com)
# You should see: "Welcome William Free Hall" along with the visitor counter!


