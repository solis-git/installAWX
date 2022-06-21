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
Após o servidor instalado, com IP configurado (de preferência também configurar o serviço de DNS para o nome da máquina) e o acesso via SSH com um usuário que tem permissão de sudo, basta copiar as linhas abaixo para instalar o servidor AWX.
```
cd ~
git clone https://github.com/solis-git/installAWX.git
cd installAWX
sh setup.sh
```
### Perguntas que devem ser respondidas durante a instalação

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

## PÓS instalação
Se você possui um arquivo de inventário com as informações de HOSTS e IP, é possível importar essas informações diretamente no banco postgreSQL do AWX. Para isso é só seguir o passo-a-passo abaixo descrito.

**Acessa o servidor AWX via SSH**
> ssh USER@AWX-SERVER

**Comanado para conectar no container do banco**
> kubectl -n awx exec -it awx-postgres-0 bash

**Comando para conectar via CLI no banco**
> psql -Uawx -p 5432 -W <password>


**É necessário executar as linhas abaixo para preparar a tabela de hosts *(main_host)* para importar os dados**
> alter table main_host alter COLUMN created set default now();
> alter table main_host alter COLUMN modified set default now();

**O arquivo CSV para importar as informações dos hosts deve conter a estrutura conforme o exemplo abaixo:**
- IMPORTANTE: verificar se os valores definidor para os campos **"created_by_id"** e **"inventory_id"** correspondem aos IDs existentes no banco.
```
"description";"name";"instance_id";"variables";"enabled";"created_by_id";"inventory_id";"ansible_facts"
"TF-SEAD-ALMOX";"TF-SEAD-ALMOX";" ";"ansible_host: 192.168.33.2";"t";1;2;"{}"
"TF-PROCURADORIA-NEF";"TF-PROCURADORIA-NEF";" ";"ansible_host: 192.168.33.6";"t";1;2;"{}"
```
**Comando para importar hosts para base, tabela "main_host"**
> \copy main_host(description,name, instance_id, variables, enabled, created_by_id, inventory_id, ansible_facts)  from '/<path/to/file>/<file>.csv' with delimiter as ';' CSV HEADER ;


