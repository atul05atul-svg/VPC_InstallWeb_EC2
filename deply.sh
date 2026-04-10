#!/bin/bash

echo "⚙️  Starting Terraform Webserver Deployment..."

# Step 1: Cleanup old key if exists
KEY_PATH="aws/server.pem"

if [ -f "$KEY_PATH" ]; then
  echo "🔁 Removing old private key..."
  rm -f "$KEY_PATH"
fi

# Step 2: Ensure aws directory exists with proper permissions
mkdir -p aws
chmod 700 aws

# Step 3: Terraform deploy
terraform init
terraform apply -auto-approve

# Step 4: Get instance IP
IP=$(terraform output -raw instance_public_ip)

if [[ -z "$IP" ]]; then
  echo "❌ Failed to fetch instance IP. Please check Terraform output."
  exit 1
fi

echo "✅ Deployment completed."
echo "🔐 Your private key is saved at $KEY_PATH"
echo "🌐 EC2 Instance Public IP: $IP"
echo "🔗 Opening http://$IP in browser..."

# Step 5: Open in browser (macOS/Linux support)
if [[ "$OSTYPE" == "darwin"* ]]; then
  open "http://$IP"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  xdg-open "http://$IP"
else
  echo "⚠️ Unable to auto-open browser on this OS. Please open manually: http://$IP"
fi