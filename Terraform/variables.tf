variable "virtual_machines" {
  type = map(object({
    autostart = bool
    running   = bool
    vm_name   = string
    cpu_cores = number
    memory    = number
    disk_size = number
    network   = string
    pool      = string
    image     = string
    user_data = string
  }))
  default = {

    "vm1" = {
      autostart = false
      running   = true
      vm_name   = "test"
      cpu_cores = 2
      memory    = 2048
      disk_size = 20 * 1024 * 1024 * 1024
      network   = "default_network"
      pool      = "default_pool"
      image     = "1.7.7.6-clone"
      user_data = <<-EOT
          #cloud-config
          hostname: new_astra
          users:
            - name: astra
              groups: astra-admin
              shell: /bin/bash
              sudo: ['ALL=(ALL) NOPASSWD:ALL']
              parsec_user_max_ilev: high
              ssh-authorized-keys:
                - somekey
          package_update: true
          packages:
            - nginx
          runcmd:
            - systemctl start nginx
        EOT
    },

  }
}