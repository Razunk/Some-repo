resource "libvirt_volume" "VM_volume" {
  for_each       = { for k, vm in var.virtual_machines : k => vm }
  name           = "${each.value.vm_name}_volume.qcow2"
  base_volume_id = "/home/astralinux.ru/dumudov/Astra_base_volumes/${each.value.image}.qcow2"
  #  source         = "https://registry.astralinux.ru/artifactory/mg-generic/alse/cloudinit/alse-gui-1.8.2.uu1-max-cloudinit-mg15.6.0-amd64.qcow2"
  format = "qcow2"
  pool   = each.value.pool
  size   = each.value.disk_size
  depends_on = [
    libvirt_pool.default_pool,
  ]
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  for_each  = { for k, vm in var.virtual_machines : k => vm }
  name      = "${each.value.vm_name}_cloudinit.iso"
  pool      = each.value.pool
  user_data = each.value.user_data
}

resource "libvirt_domain" "VM_entity" {
  for_each   = { for k, vm in var.virtual_machines : k => vm }
  autostart  = each.value.autostart
  memory     = each.value.memory
  name       = each.value.vm_name
  running    = each.value.running
  vcpu       = each.value.cpu_cores
  qemu_agent = false
  cloudinit  = libvirt_cloudinit_disk.cloudinit[each.key].id
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
  depends_on = [
    libvirt_pool.default_pool,
    libvirt_network.default_network,
  ]
}
