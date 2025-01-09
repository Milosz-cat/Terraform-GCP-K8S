resource "google_kms_key_ring" "key_ring" {
  name     = "my-new-key-ring"
  location = "europe-central2"
}

resource "google_kms_crypto_key" "crypto_key" {
  name     = "disk-encryption-key"
  key_ring = google_kms_key_ring.key_ring.id
  # rotation_period  = "7776000s" # 90 dni

  # lifecycle {
  #   prevent_destroy = true
  # }
}