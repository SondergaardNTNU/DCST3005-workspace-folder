# Obligatorisk Øving 2

Dette repoet inneholder løsningen for Oblig 2. Målet er å vise en enkel, sikker og repeterbar måte å deploye infrastruktur til flere miljøer med Terraform og GitHub Actions.

Repository: https://github.com/SondergaardNTNU/DCST3005-workspace-folder

Mappe: `module9`

Versjon: `module9-v1.1.0`

## Innholdsfortegnelse

- [Hva må være på plass](#hva-må-være-på-plass)
- [Mappestruktur](#mappestruktur)
- [Hvordan bruke secrets og tfvars](#hvordan-bruke-secrets-og-tfvars)
- [CI (Pull Request)](#ci-pull-request)
- [CD (merge til main)](#cd-merge-til-main)
- [Rollback](#rollback)

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

## Skript for lokal utvikling

I `module9/buildOnce-deployMany/scripts/` finnes tre enkle skript som hjelper deg å bygge, deploye og rydde opp. De kan kjøres lokalt eller fra CI/CD-pipeline for å sikre at samme kommandoer brukes hver gang.

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
  - Formål: Slett (destroy) resurser for et miljø, vær varsom.
  - Bruk: `./cleanup.sh <environment>`
  - Hva den gjør:
    1. Initialiserer Terraform med miljøets backend.
    2. Ber om bekreftelse (`Type 'yes' to continue`) før den kjører `terraform destroy -var-file=../environments/<env>.tfvars -auto-approve`.
  - Advarsel: Dette sletter faktiske ressurser. Kjør kun hvis du er sikker på miljøet og subscription.

Hvordan skriptene hjelper til:
- Konsistens: Skriptene sørger for at samme init/plan/apply-kommandoer brukes lokalt og i CI/CD.
- Build once: `build.sh` lager en artefakt som kan arkiveres og distribueres til forskjellige miljøer eller feature brancher, dette gjør det enklere å følge "build once, deploy many".

Eksempel lokalt (kjør i fra en `feature`-branch og ikke i `main`-branch, sørg også for å tagge slik at det er sporbart i Git hvis det skulle være behov for rollback senere.)
```bash
# Bygg artefakt for dev
./scripts/build.sh dev

# Deploy artefakten som ble laget
./scripts/deploy.sh dev terraform-dev-<versjon>.tar.gz

# Rydd opp (ADVARSEL: sletter ressurser)
./scripts/cleanup.sh dev
```

Husk: hvis du bruker secrets (tfvars i GitHub Actions), sørg for at `environments/<env>.tfvars` i artefakten inneholder riktige (og sikkert formaterte) verdier, eller at workflowen din leverer tfvars fra Actions secrets.

## CI (Pull Request)

Hva som skjer i `ci.yml`:

- Trigger: Når du åpner en PR fra en `feature`-branch mot `main` etter å ha kjørt skriptene `build.sh` og `deploy.sh`med endringer i `module9/buildOnce-deployMany/terraform/**`.
- Stegene:
  - Checkout og setup Terraform.
  - Logg inn i Azure via OIDC og sett `ARM_*`-variabler.
  - `terraform fmt -check`, `terraform init`, `terraform validate`.
  - Kjøre `terraform plan` for hvert miljø (dev, test, prod). For hvert miljø lages en TFVARS-fil ved behov (committed fil eller secret -> tempfile).
  - Plan-output postes som kommentar på PR så reviewers ser hva som vil endres.

Formålet er å oppdage feil tidlig og gi reviewers tydelig info om endringer.

## CD (merge til main)

Hva som skjer i `cd.yml`:

- Trigger: Push/merge til `main` for filer under terraform-stien.
- Stegene per miljø (sekvensielt: DEV -> TEST -> PROD):
  - Checkout, setup Terraform og Azure-login.
  - `terraform init` mot miljøets backend.
  - Forbered TFVARS (committed eller secret).
  - `terraform plan -var-file="$TFVARS_FILE" -out=tfplan`
  - `terraform show -no-color tfplan` (logg)
  - `terraform apply -auto-approve tfplan`
  - Cleanup: fjern tempfiler og `tfplan`.

Prod-deploy krever manuell godkjenning av reviewer i GitHub.

## Rollback 

1) Inspiser den tidligere versjonen (commit eller tag)

```bash
git show <commit-eller-tag>
```
Hva det gjør: Bruk dette for å bekrefte hvilken commit/tag du vil tilbakeføre til.

2) Opprett en hotfix-branch for rollback

```bash
git checkout -b hotfix/rollback-to-<tidligere-versjon>
```
Hva det gjør: Denne branchen brukes til å lage revert-PR som kan reviewes.

3) Liste eksisterende tags 

```bash
git tag -l
```
Hva det gjør: viser tilgjengelige release-tags slik at du enkelt kan peke på en tag som representerer en kjent stabil versjon.

4) Plukk ut terraform-kode fra en tidligere tag/commit

```bash
git checkout <tidligere-commit-eller-tag> -- terraform
```
Hva det gjør: henter `terraform/`-mappen fra en tidligere commit til din nåværende branch. 

5) Se status og endringer som er staged

```bash
git status
git diff --staged
```
Hva det gjør: viser hvilke filer som endres og hva som blir commit'et. Bruk dette til å verifisere at kun forventede endringer er med i rollback.

6) Commit og push hotfix-branch

```bash
git commit -m "Rollback: revert til <tidligere-versjon>"   # skriv en klar melding
git push origin hotfix/rollback-to-<tidligere-versjon>
```
Hva det gjør: oppretter commit lokalt med de valgte endringene og sender branch til remote slik at du kan opprette en PR.

Hva CI gjør når du åpner en rollback-PR
- Når du åpner PR mot `main` vil CI-pipelinen kjøre automatisk: checkout, terraform fmt, init, validate og plan for alle miljøer. 
- Sjekk PR-planene nøye: de viser hvilke endringer Terraform vil gjøre i hvert miljø. Dette er din bekreftelse på at rollback oppfører seg som forventet før merge med `main`.

7) Merge PR for rollback

Når PR er reviewet og merget til `main`, vil CD-pipelinen trigges:
- CD kjører i rekkefølge: deploy til DEV -> TEST -> PROD. Hver jobb gjør `terraform init` mot sitt backend, kjører `terraform plan -var-file=... -out=tfplan`, viser planen (`terraform show`) og så `terraform apply tfplan`.
- CD vil stoppe før prod og vente på manuell godkjenning.

8) Tagging og opprydding

Etter en vellykket rollback kan du lage en ny release-tag som dokumenterer rollbacken:

```bash
git checkout main
git pull origin main
git tag -a module9-v<nyversjon> -m "Rollback to <tidligere-versjon>: <forklaring>"
git push origin module9-v<nyversjon>
```
Hva det gjør: oppretter en annotert tag med melding og pusher den til remote slik at historikken er tydelig for senere revisjon.

9) Rydd opp lokalt og i branches 

```bash
git fetch --prune
git branch -a
```
Hva det gjør: fjerner refs som ikke finnes på remote lenger og viser alle branches sånn at du har oversikt etter rollback.

Viktig:
- Før du ruller tilbake, kontroller planen nøye i CI før du merger/lar CD kjøre apply.
- All rollback bør gå via PR så endringen blir reviewet og logget i GitHub, dette gjør handlingen sporbar.
