#!/bin/bash

#jenkins installation
sudo apt update -y
sudo apt install fontconfig openjdk-17-jre -y
sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
  https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt-get update
sudo apt-get install jenkins -y
sudo systemctl start jenkins

#docker installation
sudo apt install docker.io -y
sudo systemctl start docker

#nodejs installation
sudo apt install nodejs -y
sudo apt install npm -y


#nginx installation for deploying
sudo apt install nginx -y
sudo systemctl start nginx
sudo chown -R jenkins /var/www/html  #for writing build files
