#!/bin/#!/usr/bin/env bash
#
#
# upgrade system and discard not used packages
sudo apt update && sudo apt -y upgrade && sudo apt -y autoremove

# recomendado desabilitar firewall se possível
#sudo ufw disable

if [ $(sudo ufw status | cut -d" " -f2) = "inactive" ]
  then
    echo "WARNING: Firewall está desabilidado\n"
  else
    sudo ufw disable
    #echo -n "WARN: Firewall habilitado, liberando portas!\n"
    # echo "liberando SSH"
    #sudo ufw allow 22/tcp
    # echo "liberando ansibleAWX"
    #sudo ufw allow 6443/tcp
    #sudo ufw allow 443/tcp
    # echo "liberando VSFTP"
    #sudo ufw allow 20/tcp
    #sudo ufw allow 21/tcp
    #sudo ufw allow 40000:50000/tcp
    #sudo ufw allow 990/tcp
fi

# install k3s requisites and ftpserver
sudo apt install -y git make net-tools vsftpd

# configurando serviço de FTP (usuario de FTP sem acesso SSH)
read -p "Nome do usuário para FTP: " FTP_USER
export FTP_USER
ftp_pass=1
ftp_pass_2=2
while [ $ftp_pass != $ftp_pass_2 ]
do
  read -p "Senha do usuário para FTP: " ftp_pass
  read -p "Confirmação: " ftp_pass_2
done
FTP_USER_PASS=$(perl -e "print crypt("$ftp_pass", "salt")")
sudo useradd -m -s /bin/bash -p $FTP_USER_PASS $FTP_USER
# Deny $FTP_USER for SSH connection
echo DenyUsers $FTP_USER >> denyusers.conf
sudo mv denyusers.conf /etc/ssh/sshd_config.d/
sudo service sshd restart
# Setting UP $FTP_USER and VSFTPD Server
sudo chmod o-w /home/$FTP_USER/
sudo mkdir /home/$FTP_USER/backup_files
sudo chown $FTP_USER:$FTP_USER -R /home/$FTP_USER/
sudo mv /etc/vsftpd.conf /etc/vsftpd.conf.bak
sudo cp ~/installAWX/vsftpd.conf /etc/vsftpd.conf
sudo systemctl restart vsftpd

# k3s install
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644

# Check Kubernetes installation
sleep 5 && kubectl version --short
sleep 10 && kubectl get nodes
