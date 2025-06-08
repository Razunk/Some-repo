output "my_vms_info" {
  description = "Get VM's name and IP"
  value = [
    for vm in libvirt_domain.VM_entity : {
      vm_name = vm.name
      vm_ip   = vm.network_interface[0].addresses.0
    }
  ]
}