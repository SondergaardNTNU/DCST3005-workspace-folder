
variable "name_prefix" { default = "shs-test" }
variable "location" { default = "norwayeast" }
variable "address_space" { default = "10.31.0.0/16" }
variable "subnet_prefix" { default = "10.31.1.0/24" }
variable "vm_size" { default = "Standard_B2s" }
variable "admin_username" { default = "azureuser" }
variable "admin_ssh_public_key" { default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCe+4B3TFT+p2S6T7pz+8jbyY4/QeminiiKlhY4FUBhVe02kOdR/N/WmPIhE41QUGqG66oTfzEbzVbfMLZGTk8V3NUK0rj9GA5QrUPSoNrWFMzrI49+ytA/eqZRrpQw1y6N/EkrCYVxFw9pDLQF03buLAeuO3FwLmKWLzfOKIyDX23Uqb4mhqxPSQ9+pB48U26N9Vwnr9HHV+GTCbCohldg7Jzo7kcOi1f7kppfzwqutTeSstp4qKw92oKmciUPKBzjUKuB6I4ZAHN8ghi49dSFUVagiOUvunm7MQy1/ljdBpnhOcXINckqSRFA04Le7YsCFiUYatwrCdxvliz21AEMfBUe74KeO6cqfagnR4Fan2wV7DYXxMixI2AxcK3FFK2ya40RsxIR8v0whW8OhfUPot6pdjIkuQPlaNynm47bKSYcmaP/qKlqEXDS94c8DKacfs8zZIIAgd/vKIjpBO+n8zglnhE8yzk8SrCYx+1mvON9HP4SUgjsLbSR0uiKxfM8xhoCdWdBs0sXZztLM8RB8L2U1+qk4Yu9oFWMEGN2wdCUfWwzEJ8d5QcQUoeEy0gO3hvug8r6EFtHvA6bw808/4nYzztFPE3WDAQgr0LcCnX3PvWJ9UGsM3DCRLCHdU5Lgkfqwd0DNCm0ORUlyoG5XqAVNzBeOZtfb/rH1PCYGw== sondre.sondr@gmail.com" }
variable "subscription_id" { default = "a3adf20e-4966-4afb-b717-4de1baae6db1" }
