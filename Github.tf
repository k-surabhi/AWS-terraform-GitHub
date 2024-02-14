terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.gh_token
}

resource "github_repository" "surabhitest1" {
  name        = "projectDevops789123"
  description = "My first test"

  visibility = "public"


}