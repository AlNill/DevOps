How use this ansible role :
1. In file hosts.ini write IP-addresses of your's virtual machines
2. In folder web_server/files/site put static files of your's web_server
3. In web_server/defaults/main.yml set your's parameters:
	3.1 http_port - port in which you want to listen web_server
	3.2 server_name - web-server's domain
	3.3 document_root - folder where you want to put web-server static files

WARNING
nginx on VM must be installed!!!

RUN:
ansible-playbook site.yml -i hosts.ini -kK
