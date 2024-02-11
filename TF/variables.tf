# The file terraform.tfvas is not in version control. Minimally,
# it should contain a single line similar to the following:
# region = "us-east-1"
variable "region" {
  description = "The region Terraform deploys your instance"
  type        = string
  nullable    = false
  default     = "us-east-1"
}

variable "db_admin" {
  description = "The name of the database user."
  type        = string
  nullable    = false
  default     = "db_admin"
}

variable "db_password" {
  description = "The password for the database user (via TF_VAR.db_password)."
  type        = string
  nullable    = false
  sensitive   = true
}

variable "db_port" {
  description = "The port number used by the database server."
  type        = string
  nullable    = false
  default     = "3306"
}