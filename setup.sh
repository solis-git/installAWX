#!/bin/#!/usr/bin/env bash

echo "\nInstalação e configuração do Kubernetes (K3s) e FTP Server (vsftpd)\n"
sh 01-k3s_and_ftp-install-ubuntu2004.sh
sleep 10
echo "\nInstalação e configuração do ansibleAWX (interface Web)"
sh 02-AWXinstall.sh
