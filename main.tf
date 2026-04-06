resource "yandex_vpc_network" "network" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "public" {
  name           = var.vpc_public_name
  zone           = var.default_zone.0
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.public_cidr
}

resource "yandex_vpc_subnet" "private" {
  name           = var.vpc_private_name
  zone           = var.default_zone.0
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = var.private_cidr
  route_table_id = yandex_vpc_route_table.nat-route.id
}

data "yandex_compute_image" "ubuntu" {
  family = var.image_name
}

resource "yandex_compute_instance" "nat-instance" {
  name = var.vm_nat_name
  hostname = var.vm_nat_name
  platform_id = var.vms_platform_id

  resources {
    cores = var.vms_resources.web.cores
    memory = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = var.vm_nat_image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
    ip_address = var.vm_nat_ip_addr
  }

  metadata = {
    serial-port-enable = var.vms_meta.data.serial-port-enable
    ssh-keys           = "ubuntu:${var.vms_meta.data.ssh-keys}"
  }
  allow_stopping_for_update = true
}

resource "yandex_compute_instance" "public-vm" {
  name = var.vm_public_name
  hostname = var.vm_public_name
  platform_id = var.vms_platform_id
  resources {
    cores = var.vms_resources.web.cores
    memory = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    serial-port-enable = var.vms_meta.data.serial-port-enable
    ssh-keys           = "ubuntu:${var.vms_meta.data.ssh-keys}"
  }
  allow_stopping_for_update = true
}

resource "yandex_compute_instance" "private-vm" {
  name = var.vm_private_name
  hostname = var.vm_private_name
  platform_id = var.vms_platform_id
  resources {
    cores = var.vms_resources.web.cores
    memory = var.vms_resources.web.memory
    core_fraction = var.vms_resources.web.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    nat = false
  }

  metadata = {
    serial-port-enable = var.vms_meta.data.serial-port-enable
    ssh-keys           = "ubuntu:${var.vms_meta.data.ssh-keys}"
  } 
  allow_stopping_for_update = true
}

resource "yandex_vpc_route_table" "nat-route" {
  name       = "nat-route"
  network_id = yandex_vpc_network.network.id

  static_route {
    destination_prefix = var.any_ip
    next_hop_address   = var.vm_nat_ip_addr
  }
}
