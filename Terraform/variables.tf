variable "virtual_machines" {
  type = map(object({
    autostart = bool
    running   = bool
    vm_name   = string
    cpu_cores = number
    memory    = number
    disk_size = number
    network   = string
    image     = string
  }))
  default = {

    "vm1" = {
      autostart = false
      running   = true
      vm_name   = "dc"
      cpu_cores = 4
      memory    = 4096
      disk_size = 20 * 1024 * 1024 * 1024
      network   = "default_network"
      image     = "1.8.2.8"
    },
    "vm2" = {
      autostart = false
      running   = true
      vm_name   = "samba"
      cpu_cores = 2
      memory    = 2048
      disk_size = 20 * 1024 * 1024 * 1024
      network   = "default_network"
      image     = "1.8.2.8"
    },
    "vm3" = {
      autostart = false
      running   = true
      vm_name   = "client"
      cpu_cores = 2
      memory    = 2048
      disk_size = 20 * 1024 * 1024 * 1024
      network   = "default_network"
      image     = "1.8.2.8"
    },
    "vm4" = {
      autostart = false
      running   = true
      vm_name   = "ansile_test"
      cpu_cores = 2
      memory    = 2048
      disk_size = 20 * 1024 * 1024 * 1024
      network   = "default_network"
      image     = "1.8.2.8"
    },

  }
}