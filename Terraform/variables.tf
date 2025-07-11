variable "virtual_machines" {
  type = map(object({
    autostart = bool
    running   = bool
    vm_name   = string
    count     = string
    cpu_cores = number
    cpu_mode  = string
    memory    = number
    disk_size = number
    network   = string
    pool      = string
    image     = string
    user_data = string
  }))
  default = {

    "pacemaker" = {
      autostart = false
      running   = false
      vm_name   = "pacemaker"
      count     = 3
      cpu_cores = 2
      cpu_mode  = "custom"
      memory    = 2048
      disk_size = 20 * 1024 * 1024 * 1024
      network   = "default_network"
      pool      = "default_pool"
      image     = "1.8.2.8"
      user_data = <<-EOT
          #cloud-config
          hostname: somename
          users:
            - name: astra
              groups: astra-admin
              shell: /bin/bash
              sudo: ['ALL=(ALL) NOPASSWD:ALL']
              parsec_user_max_ilev: high
              ssh-authorized-keys:
                - ssh-ed25519 AAAAC3....zvNm administrator@example.com
        EOT
    },
    "rupost" = {
      autostart = false
      running   = false
      vm_name   = "rupost"
      count     = 1
      cpu_cores = 8
      cpu_mode  = "custom"
      memory    = 1024 * 8
      disk_size = 30 * 1024 * 1024 * 1024
      network   = "default_network"
      pool      = "default_pool"
      image     = "1.8.1.6"
      user_data = <<-EOT
          #cloud-config
          hostname: somename
          users:
            - name: astra
              groups: astra-admin
              shell: /bin/bash
              sudo: ['ALL=(ALL) NOPASSWD:ALL']
              parsec_user_max_ilev: high
              ssh-authorized-keys:
                - ssh-ed25519 AAAAC3....zvNm administrator@example.com
    },
    "ansible_module" = {
      autostart = false
      running   = false
      vm_name   = "ansible_module"
      count     = 1
      cpu_cores = 4
      cpu_mode  = "custom"
      memory    = 1024 * 4
      disk_size = 20 * 1024 * 1024 * 1024
      network   = "default_network"
      pool      = "default_pool"
      image     = "1.8.1.6"
      user_data = <<-EOT
          #cloud-config
          hostname: somename
          users:
            - name: astra
              groups: astra-admin
              shell: /bin/bash
              sudo: ['ALL=(ALL) NOPASSWD:ALL']
              parsec_user_max_ilev: high
              ssh-authorized-keys:
                - ssh-ed25519 AAAAC3....zvNm administrator@example.com
    },


  }
}
