resource "vsphere_virtual_machine" "vm" {

  name             = var.vm_name
  folder           = var.vm_folder
  num_cpus         = "8"
  memory           = "16384"
  resource_pool_id = data.vsphere_resource_pool.vsphere_resource_pool.id
  datastore_id     = data.vsphere_datastore.vsphere_datastore.id
  guest_id         = data.vsphere_virtual_machine.vm_template.guest_id
  scsi_type        = data.vsphere_virtual_machine.vm_template.scsi_type

  clone {
    template_uuid = data.vsphere_virtual_machine.vm_template.id
    timeout       = var.vm_clone_timeout
    customize {
      linux_options {
        domain    = var.vm_domain
        host_name = var.vm_name
      }

      network_interface {
        ipv4_address = var.vm_ipv4_address
        ipv4_netmask = var.vm_ipv4_prefix_length
      }

      ipv4_gateway    = var.vm_ipv4_gateway
    }
  }


  network_interface {
    network_id   = data.vsphere_network.vm_private_network.id
    adapter_type = var.vm_private_adapter_type

  }

  disk {
    label          = "${var.vm_name}.vmdk"
    size           = "200"
    keep_on_remove = "false"
    datastore_id   = data.vsphere_datastore.vsphere_datastore.id
  }
  connection {
    host                = self.default_ip_address
    type                = "ssh"
    user                = var.vm_os_user
    password            = var.vm_os_password
  }

  provisioner "file" {
    destination = "VM_add_ssh_key.sh"

    content = <<EOF
# =================================================================
# Licensed Materials - Property of IBM
# 5737-E67
# @ Copyright IBM Corporation 2016, 2017 All Rights Reserved
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================
#!/bin/bash

if (( $# != 3 )); then
echo "usage: arg 1 is user, arg 2 is public key, arg3 is Private Key"
exit -1
fi

userid="$1"
ssh_key="$2"
private_ssh_key="$3"


echo "Userid: $userid"

echo "ssh_key: $ssh_key"
echo "private_ssh_key: $private_ssh_key"


user_home=$(eval echo "~$userid")
user_auth_key_file=$user_home/.ssh/authorized_keys
user_auth_key_file_private=$user_home/.ssh/id_rsa
user_auth_key_file_private_temp=$user_home/.ssh/id_rsa_temp
echo "$user_auth_key_file"
if ! [ -f $user_auth_key_file ]; then
echo "$user_auth_key_file does not exist on this system, creating."
mkdir -p $user_home/.ssh
chmod 700 $user_home/.ssh
touch $user_home/.ssh/authorized_keys
chmod 600 $user_home/.ssh/authorized_keys
else
echo "user_home : $user_home"
fi

echo "$user_auth_key_file"
echo "$ssh_key" >> "$user_auth_key_file"
if [ $? -ne 0 ]; then
echo "failed to add to $user_auth_key_file"
exit -1
else
echo "updated $user_auth_key_file"
fi

# echo $private_ssh_key  >> $user_auth_key_file_private_temp
# decrypt=`cat $user_auth_key_file_private_temp | base64 --decode`
# echo "$decrypt" >> "$user_auth_key_file_private"

echo "$private_ssh_key"  >> "$user_auth_key_file_private"
chmod 600 $user_auth_key_file_private
if [ $? -ne 0 ]; then
echo "failed to add to $user_auth_key_file_private"
exit -1
else
echo "updated $user_auth_key_file_private"
fi
rm -rf $user_auth_key_file_private_temp

EOF

  }

provisioner "file" {
    destination = "Add_Proxy.sh"

    content = <<EOF
# =================================================================
# Licensed Materials - Property of IBM
# 5737-E67
# @ Copyright IBM Corporation 2016, 2017 All Rights Reserved
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================
#!/bin/bash

sudo echo "http_proxy=http://${var.proxy_server}" >> /etc/environment
sudo echo "proxy=http://${var.proxy_server}"    >> /etc/yum.conf
PROXY_URL="http://${var.proxy_server}/"

export http_proxy="$PROXY_URL"
export https_proxy="$PROXY_URL"
export ftp_proxy="$PROXY_URL"
export no_proxy="127.0.0.1,localhost,*.${var.vm_domain}"

# For curl
export HTTP_PROXY="$PROXY_URL"
export HTTPS_PROXY="$PROXY_URL"
export FTP_PROXY="$PROXY_URL"
export NO_PROXY="127.0.0.1,localhost,*.${var.vm_domain}"

EOF

  }

  //provisioner "local-exec" {
  //  command = "echo \"${self.clone[0].customize[0].network_interface[0].ipv4_address}       ${self.name}.${var.vm_domain} ${self.name}\" >> /tmp/${var.random}/hosts"
  //}
}

resource "null_resource" "add_ssh_key" {
  depends_on = [vsphere_virtual_machine.vm]

  connection {
    type                = "ssh"
    user                = var.vm_os_user
    password            = var.vm_os_password
    host                = var.vm_ipv4_address
  }

  
  provisioner "remote-exec" {
    inline = [
      "set -e",
      "bash -c 'chmod +x VM_add_ssh_key.sh Add_Proxy.sh'",
      "bash -c './VM_add_ssh_key.sh  \"${var.vm_os_user}\" \"${var.vm_public_ssh_key}\" \"${var.vm_private_ssh_key}\">> VM_add_ssh_key.log 2>&1'",
      "bash -c 'mv Add_Proxy.sh /etc/profile.d'",
    ]
  }
}
resource "null_resource" "vm-create_done" {
  depends_on = [
    vsphere_virtual_machine.vm,
    null_resource.add_ssh_key,
  ]

  provisioner "local-exec" {
    command = "echo 'VM creates done for ${var.vm_name}X.'"
  }
}

