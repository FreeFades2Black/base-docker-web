# Use the official lightweight Nginx image from Docker Hub
FROM nginx:alpine

# Copy our custom static webpage into the Nginx public folder
COPY index.html /usr/share/nginx/html/

# Expose port 80 so we can access it
EXPOSE 80
