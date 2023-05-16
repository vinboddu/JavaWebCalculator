#!/bin/bash
sudo yum -y update
sudo yum -y install httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo yum -y install git
sudo git clone https://github.com/digitaledify/lms-public.git /var/www/html 