module "oidc" {
  source       = "./modules/oidc"
  project_name = "it-tools"
  github_repo  = "saraartan@*/it-tools-ecs@*"
  state_bucket = "it-tools-terraform-state-712607540523"
}
