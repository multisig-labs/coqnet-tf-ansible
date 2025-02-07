set dotenv-load

CLOUDFLARE_TOKEN := env_var("CF_TOKEN")
CLOUDFLARE_ZONE := env_var("CF_ZONE")
TERRAFORM_SSH_KEY := "~/.ssh/id_ed25519.pub"

plan:
  terraform plan --var="cloudflare_api_token={{CLOUDFLARE_TOKEN}}" --var="zone_id={{CLOUDFLARE_ZONE}}" --var="terraform_ssh_key={{TERRAFORM_SSH_KEY}}" -out=plan.tfplan

apply:
  terraform apply plan.tfplan
