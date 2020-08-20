output "append_ignition" {
  value = data.local_file.append_ign.content
}

output "master_ignition" {
  value = data.local_file.master_ign
}

output "worker_ignition" {
  value = data.local_file.worker_ign
}

output "bootstrap_ignition" {
  value = data.local_file.bootstrap_ign.content
}

output "kubeadmin_password" {
  value = data.local_file.kubeadmin_password.content
}