resource "libvirt_volume" "VM_volume" {
  for_each       = { for k, vm in var.virtual_machines : k => vm }
  name           = "${each.value.vm_name}_volume.qcow2"
  base_volume_id = "/home/astralinux.ru/dumudov/Astra_base_volumes/${each.value.image}.qcow2"
  format         = "qcow2"
  pool           = "default_pool"
  size           = each.value.disk_size
}

resource "libvirt_domain" "VM_entity" {
  for_each  = { for k, vm in var.virtual_machines : k => vm }
  autostart = each.value.autostart
  memory    = each.value.memory
  name      = each.value.vm_name
  running   = each.value.running
  vcpu      = each.value.cpu_cores
  disk {
    volume_id = libvirt_volume.VM_volume[each.key].id
  }
  graphics {
    type = "vnc"
  }
  network_interface {
    network_name   = each.value.network
    wait_for_lease = true
  }
}



