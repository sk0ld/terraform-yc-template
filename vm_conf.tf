terraform {
    required_providers {
      yandex = {
        source = "yandex-cloud/yandex"
      }
    }
  }
  
  
  variable "cloud_id" {
    type = string
    description = "Yandex Cloud ID"
  }
  
  variable "folder_id" {
    type = string
    description = "Yandex Cloud folder id"
  }
  
  variable "sa_id" {
    type = string
    description = "Yandex Cloud service account id"
  }
  
  variable "token" {
    type = string
    description = "Yandex Cloud token"
  }
  
  
  variable "vm_cpu_cores" {
      type = string
      description = "Virtual machine CPU cores number"
  }
  
  variable "vm_ram" {
      type = string
      description = "Virtual machine RAM GB number"
  }

  variable "vm_name" {
      type = string
      description = "Virtual machine name"
  }


  variable "vm2_cpu_cores" {
      type = string
      description = "Virtual machine2 CPU cores number"
  }
  
  variable "vm2_ram" {
      type = string
      description = "Virtual machine2 RAM GB number"
  }

  variable "vm2_name" {
      type = string
      description = "Virtual machine2 name"
  }
locals {
    image_id = "fd8sc0f4358r8pt128gg"
    zone = "ru-central1-b"
    user_name = "pcadm"
  }
  provider "yandex" {
    token     = var.token
    cloud_id  = var.cloud_id
    folder_id = var.folder_id
    zone      = local.zone
  }
  
  resource "yandex_vpc_network" "network-1" {
    name = "network1"
  }
  resource "yandex_vpc_subnet" "subnet-1" {
    name           = "subnet1"
    zone           = "ru-central1-b"
    network_id     = yandex_vpc_network.network-1.id
    v4_cidr_blocks = ["10.129.0.0/24"]
  }
  
  resource "yandex_compute_instance" "vm" {
    name        = "${var.vm_name}"
    allow_stopping_for_update = true
  
    resources {
      cores  = "${var.vm_cpu_cores}"
      memory = "${var.vm_ram}"
      core_fraction = 20
    }
  
    boot_disk {
      initialize_params {
        image_id = local.image_id
        type     = "network-ssd"
        size = 15
      }
    }
    network_interface {
        subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
        nat = true
      }
    
      metadata = {
        user-data = "${file("/home/${local.user_name}/meta.txt")}"
      }
    
  
      provisioner "remote-exec" {
        inline = [
          "sudo apt update"
              ]
        connection {
          type     = "ssh"
          user     = local.user_name
          private_key = "${file("/home/${local.user_name}/.private_yc")}"
          host     = self.network_interface.0.nat_ip_address
        }
      }
    }

    resource "yandex_compute_instance" "vm2" {
    name        = "${var.vm2_name}"
    allow_stopping_for_update = true
  
    resources {
      cores  = "${var.vm2_cpu_cores}"
      memory = "${var.vm2_ram}"
      core_fraction = 20
    }
  
    boot_disk {
      initialize_params {
        image_id = local.image_id
        type     = "network-ssd"
        size = 15
      }
    }
    network_interface {
        subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
        nat = true
      }
    
      metadata = {
        user-data = "${file("/home/${local.user_name}/meta.txt")}"
      } 

    provisioner "remote-exec" {
        inline = [
          "sudo apt update"
              ]
        connection {
          type     = "ssh"
          user     = local.user_name
          private_key = "${file("/home/${local.user_name}/.private_yc")}"
          host     = self.network_interface.0.nat_ip_address
        }
      }
    }  
    
    output "public_ip_address_vm" {
        value = yandex_compute_instance.vm.network_interface.0.nat_ip_address
      }

    output "public_ip_address_vm2" {
        value = yandex_compute_instance.vm2.network_interface.0.nat_ip_address
      }
                               