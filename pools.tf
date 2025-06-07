resource "libvirt_pool" "default_pool" {
  name = "default_pool"
  type = "dir"
  target {
    path = "/home/astralinux.ru/dumudov/default_pool"
  }
}