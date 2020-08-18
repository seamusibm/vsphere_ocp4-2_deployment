output "append_ignition" {
  value = data.local_file.append_ign.content
}

output "master_ignition" {
  value = data.local_file.master_ign.content
}

output "worker_ignition" {
  value = data.local_file.worker_ign.content
}

output "bootstrap_ignition_path" {
  value = data.local_file.bootstrap_ign.filename
}

output "kubeadmin_password" {
  value = data.local_file.kubeadmin_password.content
}