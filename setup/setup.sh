#!/bin/bash

# Exit on error
set -e

echo "Installing system dependencies..."

# Update package lists
sudo apt-get update

# Install Make
echo "Installing Make..."
sudo apt-get install -y make

# Install Python 3.12
echo "Installing Python 3.12..."
sudo apt-get install -y software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt-get update
sudo apt-get install -y python3.12 python3.12-venv python3.12-dev

# Install Node.js
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Docker
echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
rm get-docker.sh

# Install Docker Compose
echo "Installing Docker Compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/v2.24.6/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Install Vercel CLI
echo "Installing Vercel CLI..."
sudo npm install -g vercel

echo "System dependencies installed successfully!"
echo "You can now proceed with setting up the project environment." 