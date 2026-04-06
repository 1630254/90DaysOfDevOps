resource "local_file" "ansible_inventory" {
  content  = <<EOT
[web]
web-server ansible_host=${aws_instance.web_servers[0].public_ip}

[app]
app-server ansible_host=${aws_instance.web_servers[1].public_ip}

[db]
db-server ansible_host=${aws_instance.web_servers[2].public_ip}

[all:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/demoKeyPair.pem
EOT

  filename = "${path.module}/inventory.ini"
}
