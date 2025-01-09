# Creating a dedicated service account
resource "google_service_account" "custom_service_account" {
  account_id   = "custom-sa"
  display_name = "Custom Service Account"
}

resource "google_project_iam_binding" "kms_project_access" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:${google_service_account.custom_service_account.email}"
  ]
}
