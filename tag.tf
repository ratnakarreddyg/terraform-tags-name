locals {
  tags = merge ({
    "contact"                           = var.team 
    "app"                               = var.app
    "env"                               = var.env
    "createdBy"                         = var.createdBy       
  }
  )
}
variable "team" {
  description = "The email address of the team who owns the application, ex:digitalops@gehealthcare.com"
  type        = string
}
variable "app" {
  description = "Name of the application, For ex: network, shared, ddp etc."
  type        = string
  validation {
    condition     = length(var.app) <= 6
    error_message = "The app name must be less than or equal to 6 characters."
  }
}
variable "createdBy" {
  type          = string
  description   = "Tags used for audit who created this environment"
  default       = "SRE"
}
variable "env" {
  description = "Name of the environment example: for development env it should be 'd', prod env should be 'p', testing env should be 'q' and staging env should be's'."
  type        = string
  validation {
    condition     = contains(["d", "p", "q", "s"], var.env)
    error_message = "env must be one of 'd', 'p', 'q', 's'"
  }
}
output "standard_tags" {
  description = "Name of the Final standard tags"
  value    = local.tags
}
================================
# $ cat Terraform.tfvars
#team = "dummy@gmail.com"
#env = "d"
#app = "fkart"
#createdBy = "ratnakar"