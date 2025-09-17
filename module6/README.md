# Vertikal tjenesteplattform med Terraform på Azure

## Struktur
- modules/network: VNet, Subnet, NSG
- modules/compute: VM, NIC, Public IP, NGINX
- composition/dev: Stack for dev
- composition/test: Stack for test

## Backend
AzureRM backend configured per environment in backend.hcl


## Usage
1. **Bootstrap backend**: Run `bootstrap.ps1` to create the Resource Group, Storage Account, and Container for Terraform state. Edit variables in the script to match your Azure setup and backend.hcl files.
2. **Initialize Terraform**: In each environment folder (`composition/dev` and `composition/test`), run:
	- `terraform init -backend-config=backend.hcl`
	- `terraform plan`
	- `terraform apply`
3. **Check outputs**: After apply, note the `nginx_url` output for each environment.

## Module Inputs/Outputs & Wiring
- **network module**: Inputs: `name_prefix`, `location`, `address_space`, `subnet_prefix`. Outputs: `vnet_id`, `subnet_id`.
- **compute module**: Inputs: `name_prefix`, `location`, `subnet_id`, `vm_size`, `admin_username`, `admin_ssh_public_key`. Outputs: `public_ip_address`, `nginx_url`.
- **Composition**: Wires `subnet_id` from network to compute. All variables are set in each environment's `variables.tf`.

## Naming & Tagging Standards
- All resources use a consistent `name_prefix` for easy identification.
- Tags include `environment` and `owner` ("Sondre H. Søndergaard").

## Notes
- Ensure your public IP is set for SSH access in the NSG rule in the network module.
- All code is organized as recommended in the assignment.
