#!/bin/bash

sudo useradd -r -s /usr/sbin/nologin counting-admin
sudo useradd -r -s /usr/sbin/nologin test-user
sudo mkdir -p /opt/counting
sudo mkdir -p /etc/counting
sudo mkdir -p /var/lib/counting
sudo chown -R counting-admin:counting-admin /opt/counting
sudo chown -R counting-admin:counting-admin /var/lib/counting
sudo chown -R root:counting-admin /etc/counting
sudo chmod 750 /etc/counting

sudo dnf install -y unzip
curl -fL -O https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip
unzip counting-service_linux_amd64.zip
mv counting-service_linux_amd64 counting-service
chmod +x counting-service
sudo mv counting-service /opt/counting/
sudo chown -R counting-admin:counting-admin /opt/counting
sudo chmod 755 /opt/counting/counting-service

cat <<EOF > /etc/systemd/system/counting-service.service
[Unit]
Description=Consul Demo Counting Service
After=network.target

[Service]
Type=simple
User=counting-admin
Group=counting-admin
WorkingDirectory=/opt/counting
Environment="PORT=7777"
ExecStart=/opt/counting/counting-service
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now counting-service
sudo systemctl status counting-service
