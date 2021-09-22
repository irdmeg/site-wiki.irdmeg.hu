#!/bin/bash
# mivel túl sokszor kell klienset telepítgetni
curl -O https://get.gravitational.com/teleport-v7.0.0-beta.5-linux-amd64-bin.tar.gz
tar -xzf teleport-v7.0.0-beta.5-linux-amd64-bin.tar.gz
cd teleport
sudo ./install
cd ..
rm teleport-v7.0.0-beta.5-linux-amd64-bin.tar.gz

tsh login --proxy=teleport.irdmeg.hu:443 --auth=local --user=m.peti

token=$(tctl tokens add --type=node | grep token | head -1 | awk '{print $4}')

sudo teleport start --roles=node --token=${token} --auth-server=teleport.irdmeg.hu:443 --labels=server=test --nodename=test

cat <<EOF | sudo tee /etc/systemd/system/teleport.service

[Unit]
Description=Teleport Service
After=network.target

[Service]
Type=simple
Restart=on-failure
ExecStart=sudo teleport start --roles=node --auth-server=teleport.irdmeg.hu:443 --labels=server=test --nodename=test


[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable teleport.service
sudo systemctl start teleport.service