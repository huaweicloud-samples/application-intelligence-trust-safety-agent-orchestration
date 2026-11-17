variable "hw_access_key" {
  description = "华为云 Access Key"
  type        = string
  sensitive   = true
}

variable "hw_secret_key" {
  description = "华为云 Secret Key"
  type        = string
  sensitive   = true
}

variable "hw_region" {
  description = "华为云 Region"
  type        = string
  default     = "cn-north-4"
}

variable "project_id" {
  description = "华为云 Project ID"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "Subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "enable_database" {
  description = "是否启用 GaussDB MongoDB"
  type        = bool
  default     = false
}

variable "enable_redis" {
  description = "是否启用 DCS Redis"
  type        = bool
  default     = false
}

variable "enable_apig" {
  description = "是否启用 APIG"
  type        = bool
  default     = false
}
