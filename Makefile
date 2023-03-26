
peers:
	@ansible-playbook -Dv -i peers.ini peers.yml

wireguard-key:
	@wg genkey | tee server.key | xargs ansible-vault encrypt_string --name wireguard_private_key
	@echo
	@cat server.key | wg pubkey | xargs ansible-vault encrypt_string --name wireguard_public_key
	@rm -f server.key
	@echo
