#!/bin/bash
# provision.sh: Sets up a Node.js + Nginx server

set -e # Exit immediately if any command fails. Safety first!

echo "--- STARTING PROVISIONING ---"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 1. Install Node.js if not present
if command_exists node; then
    echo "Node is already installed."
else
    echo "Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
    sudo apt-get install -y nodejs
fi

# 2. Setup Firewall
echo "Configuring Firewall..."
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx Full'
# 'yes' pipes the "y" character into the command prompt to confirm enabling
yes | sudo ufw enable 

# 3. Clone the App (Idempotency Check)
# Only clone if folder doesn't exist
if [ ! -d "/var/www/myapp" ]; then
    echo "Cloning application..."
    # sudo git clone https://github.com/myuser/myapp.git /var/www/myapp
    sudo mkdir -p /var/www/myapp # Mocking for this example
    echo "console.log('Running');" | sudo tee /var/www/myapp/app.js
fi

# 4. Setup Systemd Service for the App
# We write the service file directly using 'cat <<EOF' (Here-Document)
echo "Creating systemd service..."
cat <<EOF | sudo tee /etc/systemd/system/myapp.service
[Unit]
Description=My Node App
After=network.target

[Service]
User=root
WorkingDirectory=/var/www/myapp
ExecStart=/usr/bin/node app.js
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# 5. Start the App
sudo systemctl daemon-reload
sudo systemctl enable myapp
sudo systemctl start myapp

echo "--- PROVISIONING DONE. SERVER IS LIVE. ---"
