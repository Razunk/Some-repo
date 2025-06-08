resource "libvirt_network" "default_network" {
  addresses = [
    "192.168.105.0/24"
  ]
  autostart = true
  domain    = "default.terra"
  name      = "default_network"
  mode      = "nat"
  dns {
    enabled = true
  }
  dhcp {
    enabled = true
  }
}