#!/usr/bin/env bash
sudo apt update && sudo apt upgrade -y

#Install Nginx
echo "NGINX"
sudo apt install nginx -y
sudo service nginx restart
sudo echo service nginx status
sudo apt install sqlite -y

#Installing Synapse Server
sudo apt install -y lsb-release wget apt-transport-https
sudo wget -O /usr/share/keyrings/matrix-org-archive-keyring.gpg https://packages.matrix.org/debian/matrix-org-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/matrix-org-archive-keyring.gpg] https://packages.matrix.org/debian/ $(lsb_release -cs) main" |
    sudo tee /etc/apt/sources.list.d/matrix-org.list

sudo apt update && sudo apt upgrade -y

#Installing Matrix Synapse
echo matrix-synapse-py3 matrix-synapse/report-stats string false | debconf-set-selections
echo matrix-synapse-py3 matrix-synapse/server-name string homeserver.io | debconf-set-selections
sudo apt install matrix-synapse-py3 -y

# #Installing Redis
sudo apt install redis-server -y
echo PING | nc -q1 localhost 6379

# #Copying config file
sudo cp -r /vagrant/etc/. /etc/
sudo cp -r /vagrant/var/www/element/. /var/www/element

# #Setting up Matrix Synapse Service
sudo systemctl restart nginx.service
sudo systemctl daemon-reload
sudo systemctl enable matrix-synapse.service
sudo systemctl enable matrix-synapse-worker@sync-worker-1.service
sudo systemctl enable matrix-synapse-worker@sync-worker-2.service
sudo systemctl start matrix-synapse.target
sudo systemctl enable matrix-synapse.target