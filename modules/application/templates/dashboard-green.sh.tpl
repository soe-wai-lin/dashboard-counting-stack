#!/bin/bash

sudo useradd -r -s /usr/sbin/nologin dashboard-admin

sudo mkdir -p /opt/dashboard
sudo mkdir -p /etc/dashboard
sudo mkdir -p /var/lib/dashboard

sudo chown -R dashboard-admin:dashboard-admin /opt/dashboard
sudo chown -R dashboard-admin:dashboard-admin /var/lib/dashboard
sudo chown -R root:dashboard-admin /etc/dashboard
sudo chmod 750 /etc/dashboard

sudo dnf install -y unzip wget
wget -O dashboard-green.zip https://raw.githubusercontent.com/soe-wai-lin/hc-session-7/main/image-dir/dashboard-service-green.zip
unzip dashboard-green.zip
mv dashboard-service-green dashboard-service
sudo chmod +x dashboard-service
sudo mv dashboard-service /opt/dashboard/
sudo chown -R dashboard-admin:dashboard-admin /opt/dashboard
sudo chmod 755 /opt/dashboard/dashboard-service

cat <<EOF > /etc/systemd/system/dashboard-service.service
[Unit]
Description=Consul Demo Dashboard Service
After=network.target

[Service]
Type=simple
User=dashboard-admin
Group=dashboard-admin
WorkingDirectory=/opt/dashboard
Environment="PORT=9000"
Environment="COUNTING_SERVICE_URL=http://${counting_alb_dns}"
ExecStart=/opt/dashboard/dashboard-service
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable --now dashboard-service
sudo systemctl status dashboard-service
