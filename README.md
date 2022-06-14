# installAWX
Coleção de scripts para instalação do AnsibleAWX

O AWX fornece uma interface de usuário baseada na Web, API REST e mecanismo de tarefas construído sobre o Ansible.
É um dos projetos upstream da Red Hat Ansible Automation Platform.

##### OBS: awx-operator version 0.22.0

## Referência
##### Projetos utilizados como base para geração dos scrips de instalação

https://github.com/kurokobo/awx-on-k3s (instalação)

https://github.com/ansible/awx

## Requisitos para instalação do AnsibleAWX
- 4vcpus – Mínimo (se pode mais melhor)
- 8GB de RAM – Mínimo (se pode mais melhor)
- Ubuntu 20.04 server (com acesso a internet e a rede de gerenciamento do ativos)
- Usuário com acesso ao "sudo" (acessivel por SSH)
- 80GB de disco (particionado como abaixo)
	- 1.5G 	/boot
	- 40G	/
	- 38G	/data

## Instalação do AWX Server (interface web)
```
cd ~
git clone https://github.com/solis-git/installAWX.git
cd installAWX
sh setup.sh
```
### Perguntas que devem respondidas durante a instalação

- Definição do usuário que será utilizado para copiar os arquivos de backups dos ativos de rede:
```
Nome do usuário para FTP: <ftp user> 
Senha do usuário para FTP: <ftp user password>
Confirmação: <ftp user password>
```
- Hostname do servidor AWX, o endereço de acesso a interface será https://<hostname.do.servidor>
```
AWX Server Hostname: <hostname.do.servidor>
```
- Definição da senha do banco de dados e da senha do usuário *admin* (utilizado para conectar na interface web)
```
Senha do banco de dados (PGSQL): <root database password>
Confirmação: <root database password>
Senha do ADMIN da interface AWX: <user 'admin' interface password>
Confirmação: <user 'admin' interface password>
```
