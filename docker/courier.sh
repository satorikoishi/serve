#!/bin/bash

# Directory paths
host_directory="/home/jw/projects/serve"
container_directory="serve"
container_command_part="/bin/bash"  # Change this to match part of your container's command

# Get the container ID based on a command match
container_id=$(docker ps --format '{{.ID}} {{.Command}}' | grep "$container_command_part" | awk '{print $1}' | head -n 1)

# Check if a container was found
if [ -z "$container_id" ]; then
    echo "No container found with command part '$container_command_part'"
    exit 1
fi

# Clearing the existing content in the container's 'serve' directory
docker exec "$container_id" rm -rf /$container_directory/*

# Copy the contents of 'serve' directory from host to the container
# Note the trailing slash on the host directory path, which copies the contents of the directory
docker cp "$host_directory"/. "$container_id":"$container_directory"


# Change the ownership to root inside the container
docker exec "$container_id" chown -R root:root /$container_directory

echo "Operation completed for container: $container_id"