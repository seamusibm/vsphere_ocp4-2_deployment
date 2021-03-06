variable "openshift_version" {
  type    = string
  default = "stable-4.4"
}

variable "vsphere_network" {
  type = string
}

variable "pullsecret" {
  type = string
}
### vSphere information

variable "vsphere_datacenter" {
  type = string
}

variable "vsphere_resource_pool" {
  type = string
}

variable "clustername" {
  type = string
}

variable "proxy_server" {
  type        = string
}

### Infranode information 
variable "infranode_hostname" {
  type = string
}

variable "infranode_ip" {
  type = string
}

variable "infranode_vm_template" {
  type = string
}

variable "vm_domain_name" {
  type = string
}

variable "ocp_vm_template" {
  type = string
}

variable "infranode_vm_os_user" {
  type = string
}

variable "infranode_vm_os_password" {
  type = string
}

variable "infranode_vm_ipv4_gateway" {
  type = string
}

variable "infranode_vm_ipv4_prefix_length" {
  type = string
}

variable "vm_private_adapter_type" {
  type = string
}

variable "vm_dns_servers" {
  type = list(string)
}

variable "vm_dns_suffixes" {
  type = list(string)
}

variable "vm_clone_timeout" {
  type = string
}

variable "bootstrap_ip" {
  type = string
}

variable "master_ips" {
  type    = list(string)
}

variable "worker_ips" {
  type    = list(string)
}

variable "vm_folder" {
  type = string
}

variable "vsphere_datastore" {
  type = string
}

variable "vsphere_cluster"{
  type = string
}

variable "binaries" {
  type = map(string)
  default = {
    openshift_iso       = "https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.4/4.4.3/rhcos-4.4.3-x86_64-installer.x86_64.iso"
    openshift_bios      = "https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.4/4.4.3/rhcos-4.4.3-x86_64-metal.x86_64.raw.gz"
    openshift_kernel    = "https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.4/4.4.3/rhcos-4.4.3-x86_64-installer-kernel-x86_64"
    openshift_initramfs = "https://mirror.openshift.com/pub/openshift-v4/x86_64/dependencies/rhcos/4.4/4.4.3/rhcos-4.4.3-x86_64-installer-initramfs.x86_64.img"
    govc                = "https://github.com/vmware/govmomi/releases/download/v0.22.1/govc_linux_amd64.gz"
  }
}

variable "vsphere_image_datastore" {
  type        = string
  description = "Datastore where ISO images will be uploaded"
}

variable "vsphere_image_datastore_path" {
  type        = string
  description = "Path in vsphere_image_datastore where ISO images will be uploaded"
}

variable "no_proxies" {
  type = list(string)
}