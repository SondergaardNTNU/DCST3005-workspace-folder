
# DCST3005 Terraform App Service-plattform
## Sondre Haugland Søndergaard Obligatorisk Øving 1

## Innholdsfortegnelse

- [Filstruktur](#filstruktur)
- [Oversikt](#oversikt)
- [Moduler](#modules)
- [Stack](#stack)
- [Miljømapper](#environments)
- [Variabler](#variabler)
- [Outputs](#outputs)
- [Navngivning og tagging](#navngivning-og-tagging)
- [Kommandoer for utrulling og destruksjon](#kommandoer-for-utrulling-og-destruksjon)
- [Utfylling av *.tfvars](#utfylling-av-tfvars)


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
- `subscription_id`: Azure-abonnement.
- `environment`: Miljønavn.
- `name_prefix`: Prefiks for ressursnavn.
- `location`: Azure-region.
- `tags`: Eier, miljø, formål.
- `vnet_cidr`, `subnet_cidr`: Adresseområder for VNET og subnett.
- `sku_tier`, `sku_size`: App Service Plan, benytter free tier for lav kost.

## Outputs
Stacken eksponerer output til å vise verdier fra infrastrukturen som opprettes etter at en utrulling er fullført. Samt samle og sende videre output til modulene.
- `app_service_id`: ID for webapplikasjonen.
- `app_service_default_hostname`: Standard hostname.
- `network_subnet_id`: Subnett-ID, brukes bla. for å sette opp VNET integrasjon med WebApplikasjonen.
- `network_vnet_name`: VNet-navn.
- `resource_group_name`: RG-navn.


## Navngivning og tagging
Navngivning og tagging håndteres med `locals.tf` for konsekvent navngivning og tagging. Ressursnavn settes basert på miljø (dev, prod eller test), prefiks (shs) og eier. Tags inkluderer miljø, eier og formål.

## Kommandoer for utrulling og destruksjon

`../Environments/Dev`
Kjør følgende kommandoer: 

```sh
terraform init
terraform plan -var-file="dev.terraform.tfvars" -out=dev-tfplan
terraform apply "dev-tfplan"
```

For å destruere:
```sh
terraform destroy -var-file="dev.terraform.tfvars"
```

`../Environments/Prod`
Kjør følgende kommandoer: 

```sh
terraform init
terraform plan -var-file="prod.terraform.tfvars" -out=prod-tfplan
terraform apply "prod-tfplan"
```

For å destruere:
```sh
terraform destroy -var-file="prod.terraform.tfvars"
```


`../Environments/Test`
Kjør følgende kommandoer: 

```sh
terraform init
terraform plan -var-file="test.terraform.tfvars" -out=test-tfplan
terraform apply "test-tfplan"
```

For å destruere:
```sh
terraform destroy -var-file="test.terraform.tfvars"
```




## Utfylling av *.tfvars

### Slik fyller du ut *.tfvars-filen for et miljø

Alle variabler som styrer ressursene for miljøet må settes i *.tfvars-filen. Dette sikrer at du kan bruke samme stack og moduler for Dev, Test og Prod, men med ulike verdier.

Eksempel innhold i `dev.terraform.tfvars` under `../Environments/Dev`:

```hcl
subscription_id = "<din-azure-subscription-id>"
environment     = "dev"                # Miljønavn, f.eks. dev, test, prod
name_prefix     = "shs-devapp"         # Prefiks for ressursnavn
location        = "Norway East"        # Azure-region
vnet_cidr       = "10.0.0.0/16"        # Adresseområde for VNet
subnet_cidr     = "10.0.1.0/24"        # Adresseområde for subnett
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
- `name_prefix`: Prefiks for alle ressursnavn, gir unikhet, her brukes f.eks. "shs".
- `location`: Azure-region, f.eks. "Norway East".
- `vnet_cidr` og `subnet_cidr`: Adresseområder for nettverket.
- `tags`: Map med eier, miljø og formål for ressursene.
- `sku_tier` og `sku_size`: Styrer kostnad for App Service Plan.
- `linux_fx_version`: Docker-image for Linux Web App.
- `scm_type`: Source control type (f.eks. LocalGit).
- `SOME_KEY`: Eksempel på app setting, kan tilpasses.


Du kan kopiere og tilpasse eksempelet over for Dev, Test og Prod, og endre verdier etter behov.



