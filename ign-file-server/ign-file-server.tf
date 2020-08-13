resource "null_resource" "copy_ign_file" {

  connection {
    type                = "ssh"
    private_key         = var.infra_private_key
    host                = var.infra_host
  }

  provisioner "file" {
    source = "./installer-files/bootstrap.ign"
    destination = "/tmp/ignition"
  }
  

  provisioner "remote-exec" {
    inline = [
      "systemctl stop firewalld",
      "yum install httpd -y",
      "systemctl start httpd",
      "ln -s /tmp/ignition /var/www/html"
    ]
  }
}

resource "null_resource" "web_server_created" {
  depends_on = [
    null_resource.copy_ign_file
  ]
  provisioner "local-exec" {
    command = "echo 'Web server created'"
  }
}