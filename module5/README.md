# DCST3005 Terraform App Service-plattform

## Filstruktur

```
module5/
├── Environments/
│   ├── Dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── dev.terraform.tfvars
│   ├── Test/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── test.terraform.tfvars
│   └── Prod/
│       ├── main.tf
│       ├── variables.tf
│       └── prod.terraform.tfvars
├── Modules/
│   ├── Network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── locals.tf
│   └── AppService/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── locals.tf
└── Stacks/
    ├── main.tf
    ├── outputs.tf
    └── variables.tf
```

## Oversikt

Denne løsningen oppretter i Azure et nettverkslag og et applikasjonslag, og kan kjøres i flere miljøer (Dev, Test, og Prod). Nettverkslaget etablerer VNet, subnett og nettverkssikkerhetsgruppe. Applikasjonslaget oppretter en App Service Plan og en Linux Web App.

### `../Modules`
- **`../Modules/Network`**: Oppretter VNet, subnett og NSG. Parametriseres via variabler.
- **`../Modules/AppService`**: Oppretter en App Service Plan og Linux App Service. Tar i bruk outputs (subnet_id) fra Network-modulen for integrasjon med VNET-et.

### `../Stack`
- Komponerer modulene og kobler outputs fra Network til inputs i AppService.

### `../Environments`
- Hver miljømappe (Dev, Test, Prod) lager et instans med bruk av modulene fra `../Stacks` og tar input fra variabler via *.tfvars filene.

## Variabler
Alle forskjeller mellom miljøer styres via inputvariabler, f.eks.:
- `subscription_id`: Azure-abonnement
- `environment`: Miljønavn
- `name_prefix`: Prefiks for ressursnavn
- `location`: Azure-region
- `tags`: Eier, miljø, formål
- `vnet_cidr`, `subnet_cidr`: Adresseområder
- `sku_tier`, `sku_size`: App Service Plan, benytter free tier for lav kost.

## Outputs
Stacken eksponerer bl.a.:
- `app_service_id`: ID for webapplikasjonen
- `app_service_default_hostname`: Standard hostname
- `network_subnet_id`: Subnett-ID
- `network_vnet_name`: VNet-navn

## Navngivning og tagging
Navngivning og tagging håndteres med `locals.tf` for konsekvent navngivning og tagging. Ressursnavn settes basert på miljø (dev, prod eller test), prefiks (shs) og rolle. Tags inkluderer miljø, eier og formål.

## Kommandoer for utrulling og destruksjon

Kjør følgende kommandoer fra ønsket miljømappe (f.eks. `Environments/Dev`):

```sh
terraform init
terraform plan -var-file="dev.terraform.tfvars" -out=dev-tfplan
terraform apply "dev-tfplan"
```

For å destruere:
```sh
terraform destroy -var-file="dev.terraform.tfvars"
```

## Utfylling av *.tfvars

### Slik fyller du ut *.tfvars-filen for et miljø

Alle variabler som styrer ressursene for miljøet må settes i *.tfvars-filen. Dette sikrer at du kan bruke samme stack og moduler for Dev, Test og Prod, men med ulike verdier.

Eksempel på innhold i `dev.terraform.tfvars`:

```hcl
subscription_id = "<din-azure-subscription-id>"
environment     = "dev"                # Miljønavn, f.eks. dev, test, prod
name_prefix     = "shs-devapp"         # Prefiks for ressursnavn
location        = "Norway East"        # Azure-region
vnet_cidr       = "10.0.0.0/16"        # Adresseområde for VNet
subnet_cidr     = "10.0.1.0/24"        # Adresseområde for subnett
allow_ssh_cidr  = "0.0.0.0/0"          # CIDR for SSH-tilgang (valgfritt, brukes kun for VM)
tags = {
    owner      = "Sondre H. Søndergaard" # Eier
    environment = "Development"           # Beskrivelse av miljø
}
sku_tier   = "Free"                    # App Service Plan tier (Free for lav kost)
sku_size   = "F1"                      # App Service Plan størrelse (F1 for lav kost)
linux_fx_version = "DOCKER|mcr.microsoft.com/azure-app-service/samples/aspnetcore-helloworld:latest" # Docker-image for Linux Web App
scm_type   = "LocalGit"                # Source control type
SOME_KEY   = "some-value"              # Eksempel på app setting
```

**Forklaring på variabler:**
- `subscription_id`: Azure-abonnementet ressursene skal opprettes i.
- `environment`: Navn på miljøet, brukes i ressursnavn og tagging.
- `name_prefix`: Prefiks for alle ressursnavn, gir unikhet.
- `location`: Azure-region, f.eks. "Norway East".
- `vnet_cidr` og `subnet_cidr`: Adresseområder for nettverket.
- `allow_ssh_cidr`: Hvilke IP-adresser som kan få SSH-tilgang (valgfritt, kun relevant for VM).
- `tags`: Map med eier, miljø og formål for ressursene.
- `sku_tier` og `sku_size`: Styrer kostnad for App Service Plan.
- `linux_fx_version`: Docker-image for Linux Web App.
- `scm_type`: Source control type (f.eks. LocalGit).
- `SOME_KEY`: Eksempel på app setting, kan tilpasses.

- `purpose`: Formål med miljøet/prosjektet.
- `cost_center`: Kostnadssted for ressursene.

Du kan kopiere og tilpasse eksempelet over for Test og Prod, og endre verdier etter behov.


## Verifikasjon
Outputs fra stacken gir ressursnavn og hostname for webapplikasjonen, slik at du kan kontrollere at alt er opprettet korrekt.

