#!/bin/bash

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

