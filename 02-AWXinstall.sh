#!/bin/#!/usr/bin/env bash
#
# based on https://github.com/kurokobo/awx-on-k3s installation
#
# Install AWX Operator
cd ~
git clone https://github.com/ansible/awx-operator.git
cd awx-operator
git checkout 0.22.0
# Exporte o nome do namespace no qual você deseja implantar o AWX Operator como a variável de ambiente NAMESPACE e execute "make deploy". O namespace padrão é awx.
export NAMESPACE=awx
make deploy
#
echo "O AWX Operator será implantado no namespace que você especificou.\n"
kubectl -n awx get all
#
# Customizações no ambiente (gerar certificado auto-assinado, definir senha padrão para admin da interface AWX e postgresql e criando diretório para volume de dados permanente.)
#
cd ~
git clone https://github.com/kurokobo/awx-on-k3s.git
cd awx-on-k3s
# Set AWX Server hostname
read -p "AWX Server Hostname: " AWX_HOST
export AWX_HOST
openssl req -x509 -nodes -days 3650 -newkey rsa:2048 -out ./base/tls.crt -keyout ./base/tls.key -subj "/CN=${AWX_HOST}/O=${AWX_HOST}" -addext "subjectAltName = DNS:${AWX_HOST}"
sed -i "s/hostname:.*/hostname: $AWX_HOST/" base/awx.yaml
#
# Password definition
echo "Antes de seguir a instalação você deve definir as senhas do banco de dados e do admin da interface\n\nObserve que a senha em awx-postgres-configuration não deve conter aspas simples ou duplas (', \") ou barras invertidas (\) para evitar problemas durante a implantação, backup ou restauração\n"
pgsql_pass=1
pgsql_pass_2=2
while [ $pgsql_pass != $pgsql_pass_2 ]
do
  read -p "Senha do banco de dados (PGSQL): " pgsql_pass
  read -p "Confirmação: " pgsql_pass_2
done
cd ~/awx-on-k3s
sed -i "{0,/password=.*/ s/password=.*/password=$pgsql_pass/}" base/kustomization.yaml
#
awx_admin_pass=1
awx_admin_pass_2=2
while [ $awx_admin_pass != $awx_admin_pass_2 ]
do
  read -p "Senha do ADMIN da interface AWX: " awx_admin_pass
  read -p "Confirmação: " awx_admin_pass_2
done
cd ~/awx-on-k3s
sed  -i "0,/password=/! {0,/password=.*/ s/password=.*/password=$awx_admin_pass/}" base/kustomization.yaml

# cria diretórios (volumes permanentes) para projetos e base de dados
echo "Criando diretórios para volumes de dados permanentes..."
sudo mkdir -p /data/postgres
sudo mkdir -p /data/projects
sudo chmod 755 /data/postgres
sudo chown 1000:0 /data/projects

# Aplicando as configurações
echo "Aplicando alterações na instalação do AWX..."
kubectl apply -k base

# finalizando
sleep 3
echo "Para monitorar o progresso da implantação, verifique os logs de implantações com o comando:\n\n
kubectl -n awx logs -f deployments/awx-operator-controller-manager -c awx-manager
\n"
echo "Quando a implantação for concluída com êxito, os logs terminarão com:\n\n
----- Ansible Task Status Event StdOut (awx.ansible.com/v1beta1, Kind=AWX, awx/awx) -----


PLAY RECAP *********************************************************************
localhost                  : ok=65   changed=0    unreachable=0    failed=0    skipped=44   rescued=0    ignored=0


----------
\n\n"
echo "Seu servidor ansibleAWX estará disponível em:\n\n https://$AWX_HOST/\n"
