variable "project_id" {
  description = "Project ID on GCP"
  type        = string
}

variable "region" {
  description = "Region GCP"
  type        = string
}

variable "zone" {
  description = "Zone in the region"
  type        = string
}

variable "ssh_user" {
  description = "Username for SSH connection"
  type        = string
}

variable "vm_names" {
  description = "List of names for virtual machines"
  type        = list(string)
  default     = ["test-master", "test-worker-1", "test-worker-2"]
}

variable "disk_encryption_key_raw" {
  description = "The base64 encoded disk encryption key for CSEK"
  type        = string
  sensitive   = true
}