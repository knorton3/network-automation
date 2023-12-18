#!/bin/bash

echo "Apache Installation"
sudo apt update
sudo apt upgrade -y
sudo apt install apache2 -y
sudo systemctl status apache2

echo "Apache Configuration"
sudo mkdir /var/www/netdevops
sudo chown -R $USER:$USER /var/www/netdevops
sudo chmod -R 777 /var/www/netdevops
sudo touch /etc/apache2/sites-available/netdevops.conf
echo "<VirtualHost *:80>" | sudo tee -a /etc/apache2/sites-available/netdevops.conf
echo "    ServerAdmin webmaster@localhost" | sudo tee -a /etc/apache2/sites-available/netdevops.conf
echo "    ServerName $HOSTNAME" | sudo tee -a /etc/apache2/sites-available/netdevops.conf
echo "    ServerAlias $HOSTNAME" | sudo tee -a /etc/apache2/sites-available/netdevops.conf
echo "    DocumentRoot /var/www/netdevops" | sudo tee -a /etc/apache2/sites-available/netdevops.conf
echo "    ErrorLog ${APACHE_LOG_DIR}/error.log" | sudo tee -a /etc/apache2/sites-available/netdevops.conf
echo "    CustomLog ${APACHE_LOG_DIR}/access.log combined" | sudo tee -a /etc/apache2/sites-available/netdevops.conf
echo "</VirtualHost>" | sudo tee -a /etc/apache2/sites-available/netdevops.conf

echo "Update Apache"
sudo a2ensite netdevops.conf
sudo a2dissite 000-default.conf
sudo apache2ctl configtest
sudo systemctl restart apache2

echo "Git Installation"
GIT_VERSION="$(git --version)"
echo ${GIT_VERSION}
if [[ "${GIT_VERSION#*.}" > "25.0"  ]]; then
    echo "Git is higher than 2.25.0"
  else
    echo "Git is lower than 2.25.0"
    sudo apt-get install git -y
fi
sudo apt-get update -y
sudo apt-get install git-lfs -y

echo "Python Installation"
PYTHON_VERSION="$(python --version)"
echo ${PYTHON_VERSION}
if [[ "${PYTHON_VERSION#*.}" < "8.9"  ]]; then
    echo "Python is higher than 3.8.9"
  else
    echo "Git is 3.8.10 or lower"
    sudo apt install python3
fi
echo "Install PIP and Virtual Environment"
sudo apt install python3-pip -y
sudo apt install python3-venv -y

echo "Installation of Ansible"
sudo apt -y install software-properties-common
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get install ansible -y
pip install ansible-pylibssh

echo "Installation of Docker"
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
echo \
"deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
"$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
systemctl status docker
sudo usermod -a -G docker $USER
sudo apt-get install docker-compose -y

echo "Installation of ContainerLab"
bash -c "$(curl -sL https://get.containerlab.dev)"

echo "Installation of Samba"
sudo apt install samba -y
echo "[share]" | sudo tee -a /etc/samba/smb.conf
echo "comment = Shared Folder" | sudo tee -a /etc/samba/smb.conf
echo "path = /home/$USER/network-automation" | sudo tee -a /etc/samba/smb.conf
echo "writeable = yes" | sudo tee -a /etc/samba/smb.conf
echo "browseable = yes" | sudo tee -a /etc/samba/smb.conf
echo "public = no" | sudo tee -a /etc/samba/smb.conf
sudo service smbd restart
sudo smbpasswd -a $USER