# Obligatorisk Øving 2: Build Once, Deploy Many (Azure + Terraform)

Dette repoet inneholder løsningen for Oblig 2. Målet er å vise en enkel, sikker og repeterbar måte å deploye infrastruktur til flere miljøer med Terraform og GitHub Actions.

Les denne README-en for hva som må være på plass, hvordan repoet er organisert, og hvordan du kjører ting lokalt og i CI/CD.

Repository: https://github.com/SondergaardNTNU/DCST3005-workspace-folder

Mappe: module9

Versjon: module9-v1.1.0

## Innholdsfortegnelse

- [Hva må være på plass](#hva-må-være-på-plass)
- [Mappestruktur](#mappestruktur)
- [Hvordan bruke secrets og tfvars](#hvordan-bruke-secrets-og-tfvars)
- [CI (Pull Request)](#ci-pull-request)
- [CD (merge til main)](#cd-merge-til-main)

---

## Hva må være på plass

- Azure-abonnement med rettigheter til å opprette Resource Groups, Storage Accounts og Key Vault.
- Et GitHub-repo med Actions aktivert.
- Secrets i GitHub for Azure-innlogging og (valgfritt) tfvars-innhold per miljø.

Anbefalt: Beskytt `prod`-miljøet i GitHub (kreve godkjenning før deploy).

## Mappestruktur

```
module9/
  buildOnce-deployMany/
    backend-configs/     # Per-miljø .tfstate 
    environments/        # Per-miljø .tfvars (bruker github secrets i mitt oppsett)
      dev.tfvars
      test.tfvars
      prod.tfvars
    scripts/              # build.sh, deploy.sh, cleanup.sh
    shared/               # backend.hcl
    terraform/            # backend.tf, main.tf, variables.tf, outputs.tf
  workflows/              # kopier av .github/workflows for innlevering
```

Kort forklaring:
- `environments/`: inneholder miljøspesifikke verdier. Hvis disse er sensitive, legg dem i GitHub Secrets i stedet for å committe.
- `terraform/`: koden som definerer Resource Group og Storage Account (minimumskrav for øvingen).

Merknad om workflow-lokasjon
- Workflow-filene som ligger i denne mappen (`module9/workflows/ci.yml` og `module9/workflows/cd.yml`) er kopier for innlevering/oversikt. De originale workflow-filene ligger i repoets rot under `.github/workflows/` (dvs. `DCST3005-workspace-folder/.github/workflows/`).
- På grunn av dette kan enkelte relative stier som brukes i workflow-filene (for eksempel `-backend-config="../shared/backend.hcl"` eller sti til `module9/...`) trenge justering hvis du flytter eller kjører workflow-filene fra en annen plassering. Sjekk og oppdater paths i workflowene dersom du får feilmeldinger om at filer ikke finnes.

## Hvordan bruke secrets og tfvars

To måter å gi miljøverdier til workflowene:

1. Committe `module9/buildOnce-deployMany/environments/<env>.tfvars` i repoet. Workflow bruker disse først hvis de finnes.
2. Hvis filen ikke finnes, leser workflow en repository secret (`DEV_TFVARS`, `TEST_TFVARS`, `PROD_TFVARS`) og skriver den til en midlertidig fil (umask 077) som Terraform bruker.

Viktig: innholdet i tfvars-secrets må være gyldig `.tfvars` HCL. Eksempel (DEV):

```hcl
prefix = "shs"
env = "dev"
location = "norwayeast"
storage_tier = "Standard"
replication = "LRS"
tags = {
  env     = "dev"
  owner   = "Sondre H. Søndergaard"
  project = "DCST3005"
}
```

Merk: i denne innleveringen ble miljø-verdiene for dev/test/prod levert som GitHub Actions secrets (`DEV_TFVARS`, `TEST_TFVARS`, `PROD_TFVARS`) når workflowene ble kjørt.

## Skript

I `module9/buildOnce-deployMany/scripts/` finnes tre enkle skript som hjelper deg å bygge, deploye og rydde opp. De kan kjøres lokalt eller fra en CI/CD-pipeline for å sikre at samme kommandoer brukes hver gang.

- build.sh
  - Formål: Validerer Terraform, initialiserer backend for et gitt miljø, og pakker repo-delen til en artifact (.tar.gz).
  - Bruk: `./scripts/build.sh <environment>` hvor `<environment>` er `dev`, `test` eller `prod`.
  - Hva den gjør:
    1. Kjører `terraform fmt` og `terraform validate` i `terraform/`.
    2. Kaller `terraform init -reconfigure` med backend-config for miljøet (fra `backend-configs/backend-<env>.tfvars`).
    3. Lager en tar.gz som inneholder `terraform/`, `shared/backend.hcl`, `backend-configs/backend-<env>.tfvars` og `environments/<env>.tfvars`.
  - Tips: Scriptet bruker git commit-hash som versjon hvis det kjøres i et git-repo. Artefaktnavnet gjør det enkelt å spore hva som er bygget.

- deploy.sh
  - Formål: Packer ut en tidligere laget artifact og kjører `terraform apply` for et gitt miljø.
  - Bruk: `./scripts/deploy.sh <environment> <artifact>`
  - Hva den gjør:
    1. Sjekker at `az` CLI er logget inn og henter subscription-id (`az account show`).
    2. Unpacker artifact og initialiserer Terraform med riktig backend-config (`backend-configs/backend-<env>.tfvars`).
    3. Kjører `terraform apply -var-file=../environments/<env>.tfvars -auto-approve`.
  - Forutsetninger: `az login` er utført, og brukeren har rettigheter i subscriptionen. Hvis du bruker Actions/OIDC i CI, er denne delen erstattet av workflowens OIDC-login.

- cleanup.sh
  - Formål: Slett (destroy) resurser for et miljø — bruk med ekstrem forsiktighet.
  - Bruk: `./cleanup.sh <environment>`
  - Hva den gjør:
    1. Initialiserer Terraform med miljøets backend.
    2. Ber om bekreftelse (`Type 'yes' to continue`) før den kjører `terraform destroy -var-file=../environments/<env>.tfvars -auto-approve`.
  - Advarsel: Dette sletter faktiske ressurser. Kjør kun hvis du er sikker på miljøet og subscription.

Hvordan skriptene hjelper til:
- Konsistens: Skriptene sørger for at samme init/plan/apply-kommandoer brukes lokalt og i CI/CD.
- Build once: `build.sh` lager en artefakt som kan arkiveres og distribueres til forskjellige miljøer, dette gjør det enklere å følge "build once, deploy many".
- Gjenbruk i workflows: Workflowene kan kalle disse skriptene (eller samme kommandoer), for eksempel for å bygge artefakt i CI og deretter bruke `deploy.sh` i CD.

Eksempel (lokalt)
```bash
# Bygg artefakt for dev
./scripts/build.sh dev

# Deploy artefakten som ble laget
./scripts/deploy.sh dev terraform-dev-<version>.tar.gz

# Rydd opp (ADVARSEL: sletter ressurser)
./scripts/cleanup.sh dev
```

Husk: hvis du bruker secrets (tfvars i GitHub Actions), sørg for at `environments/<env>.tfvars` i artefakten inneholder riktige (og sikkert formaterte) verdier, eller at workflowen din leverer tfvars fra Actions secrets.

## CI (Pull Request)

Hva som skjer i `ci.yml`:

- Trigger: Når du åpner en PR mot `main` med endringer i `module9/buildOnce-deployMany/terraform/**`.
- Stegene:
  - Checkout og setup Terraform.
  - Logg inn i Azure via OIDC og sett `ARM_*`-variabler.
  - `terraform fmt -check`, `terraform init`, `terraform validate`.
  - Kjøre `terraform plan` for hvert miljø (dev, test, prod). For hvert miljø lages en TFVARS-fil ved behov (committed fil eller secret → tempfile).
  - Plan-output postes som kommentar på PR så reviewers ser hva som vil endres.

Formålet er å oppdage feil tidlig og gi reviewers tydelig info om endringer.

## CD (merge til main)

Hva som skjer i `cd.yml`:

- Trigger: Push/merge til `main` for filer under terraform-stien.
- Stegene per miljø (sekvensielt: DEV → TEST → PROD):
  - Checkout, setup Terraform og Azure-login.
  - `terraform init` mot miljøets backend.
  - Forbered TFVARS (committed eller secret).
  - `terraform plan -var-file="$TFVARS_FILE" -out=tfplan`
  - `terraform show -no-color tfplan` (logg)
  - `terraform apply -auto-approve tfplan`
  - Cleanup: fjern tempfiler og `tfplan`.

Prod-deploy krever manuell godkjenning i GitHub.



