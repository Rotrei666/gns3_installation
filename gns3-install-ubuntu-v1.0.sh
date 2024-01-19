#!/bin/bash

apt 

add-apt-repository -y ppa:gns3/ppa
apt update                                
apt install -y gns3-gui -y gns3-server

dpkg --add-architecture i386
apt update
apt install -y gns3-iou

apt remove docker docker-engine docker.io
snap remove docker

apt-get install apt-transport-https ca-certificates curl \ software-properties-common

apt  install curl
curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  apt-key add -

add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) stable"


apt update
apt install -y docker-ce

usermod -aG ubridge,libvirt,kvm,wireshark,docker $(whoami)


file="/etc/systemd/system/gns3server.service"

user_name=$(logname)

cat <<EOF > $file
[Unit]
Description=GNS3 Server
[Service]
User=$user_name
Group=$user_name
ExecStart=/usr/share/gns3/gns3-server/bin/gns3server
[Install]
WantedBy=multi-user.target
EOF

echo "File created succefully"

chmod +x /etc/systemd/system/gns3server.service
systemctl enable gns3server.service
systemctl start gns3server.service
systemctl status gns3server.service
