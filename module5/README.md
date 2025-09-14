# DCST3005 Terraform App Service-plattform

## Prosjektstruktur

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

Denne løsningen oppretter en plattform i Azure med et nettverkslag og et applikasjonslag, og kan kjøres i flere miljøer (dev, test, prod). Nettverkslaget etablerer ressursgruppe, VNet, subnett og nettverkssikkerhetsgruppe. Applikasjonslaget oppretter en App Service Plan og en Linux Web App.

### Moduler
- **Network**: Oppretter ressursgruppe, VNet, subnett og NSG. Parametriseres via variabler.
- **AppService**: Oppretter App Service Plan og Web App. Konsumerer outputs fra Network-modulen.

### Stack
- Komponerer modulene og kobler outputs fra Network til inputs i AppService.
- Eksponerer relevante outputs for verifikasjon.

### Miljømapper
- Hver miljømappe (Dev, Test, Prod) instansierer stacken og leverer variabler via *.tfvars.
- Ingen miljøspesifikke verdier er hardkodet i modulene.

## Variabler
Alle forskjeller mellom miljøer styres via inputvariabler, f.eks.:
- `subscription_id`: Azure-abonnement
- `environment`: Miljønavn
- `name_prefix`: Prefiks for ressursnavn
- `location`: Azure-region
- `tags`: Eier, miljø, formål
- `vnet_cidr`, `subnet_cidr`: Adresseområder
- `sku_tier`, `sku_size`: App Service Plan

## Outputs
Stacken eksponerer bl.a.:
- `app_service_id`: ID for webapplikasjonen
- `app_service_default_hostname`: Standard hostname
- `network_subnet_id`: Subnett-ID
- `network_vnet_name`: VNet-navn

## Navngivning og tagging
Navngivning og tagging håndteres med `locals` for konsistens. Ressursnavn settes basert på miljø, prefiks og rolle. Tags inkluderer miljø, eier og formål.

## Kommandoer for utrulling og destruksjon

Kjør følgende kommandoer fra ønsket miljømappe (f.eks. `Environments/Dev`):

```sh
terraform init
terraform plan -var-file="dev.terraform.tfvars"
terraform apply -var-file="dev.terraform.tfvars"
```

For å destruere:
```sh
terraform destroy -var-file="dev.terraform.tfvars"
```

## Utfylling av *.tfvars
Fyll inn alle variabler som kreves for ditt miljø i den aktuelle *.tfvars-filen. Se eksempel i `dev.terraform.tfvars`.

## Forutsetninger
- Terraform installert
- Tilgang til Azure-konto
- Azure CLI autentisert eller subscription_id angitt

## Verifikasjon
Outputs fra stacken gir ressursnavn og hostname for webapplikasjonen, slik at du kan kontrollere at alt er opprettet korrekt.

