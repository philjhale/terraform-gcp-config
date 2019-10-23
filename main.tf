// This file contains some example Terrform code
resource "google_service_account" "example_service_account" {
  account_id   = "example-service-account"
  display_name = "Created by Terraform"
}