variable "project_name" {
  type        = string
  description = "Project name"
}

variable "region" {
  type        = string
  default     = "europe-west1"
  description = "GCP region"
}

variable "subnet" {
  type        = string
  description = "VPC subnet used for deployment"
}

variable "machine_type" {
  type        = string
  default     = "e2-medium"
  description = "Machine type to use for both worker and master nodes"
}

variable "workers_count" {
  type        = number
  description = "Count of worker nodes in cluster"
  default     = 2
}

variable "image_version" {
  type    = string
  default = "2.1.27-ubuntu20"
}