# installAWX
Coleção de scripts para instalação do AnsibleAWX

O AWX fornece uma interface de usuário baseada na Web, API REST e mecanismo de tarefas construído sobre o Ansible.
É um dos projetos upstream da Red Hat Ansible Automation Platform.

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

## Install AWX Server (web interface)

cd ~
git clone https://github.com/solis-git/installAWX.git
cd installAWX
