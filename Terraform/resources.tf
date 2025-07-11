locals {
  vm_instances = flatten([
    for vm_key, vm in var.virtual_machines : [
      for index in range(vm.count) : {
        key      = "${vm_key}-${index}"
        vm_key   = vm_key
        vm_name  = "${vm.vm_name}-${index}"
        settings = vm
      }
    ]
  ])
  vm_instances_map = { for instance in local.vm_instances : instance.key => instance }
}

resource "libvirt_volume" "VM_volume" {
  for_each       = local.vm_instances_map
  name           = "${each.value.vm_name}_volume.qcow2"
  base_volume_id = "/home/astralinux.ru/dumudov/Astra_base_volumes/${each.value.settings.image}.qcow2"
  format         = "qcow2"
  pool           = each.value.settings.pool
  size           = each.value.settings.disk_size
  depends_on = [
    libvirt_pool.default_pool,
  ]
}

resource "libvirt_cloudinit_disk" "cloudinit" {
  for_each  = local.vm_instances_map
  name      = "${each.value.vm_name}_cloudinit.iso"
  pool      = each.value.settings.pool
  user_data = each.value.settings.user_data
}

resource "libvirt_domain" "VM_entity" {
  for_each   = local.vm_instances_map
  autostart  = each.value.settings.autostart
  memory     = each.value.settings.memory
  name       = each.value.vm_name
  running    = each.value.settings.running
  vcpu       = each.value.settings.cpu_cores
  qemu_agent = false
  cloudinit  = libvirt_cloudinit_disk.cloudinit[each.key].id
  cpu {
    mode = each.value.settings.cpu_mode
  }

  disk {
    volume_id = libvirt_volume.VM_volume[each.key].id
  }
  graphics {
    type = "vnc"
  }
  network_interface {
    network_name   = each.value.settings.network
    wait_for_lease = true
  }
  depends_on = [
    libvirt_pool.default_pool,
    libvirt_network.default_network,
  ]
}
