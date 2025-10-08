locals {
  # Map of resource types to separators
  resource_separator_map = {
    "ks" = "_"
    "kst" = "_"
  }
  random_string_results = [
    for r in random_string.random_digits : r.result
  ]
  # Default separator if resource type is not in the map
  default_separator = "-"
  # Determine the separator based on the resource type
  separator = lookup(local.resource_separator_map, var.resource, local.default_separator)
  # Concatenate parts with the appropriate separator
  name = [for result in local.random_string_results : "${var.env}${local.separator}${var.app}${local.separator}${var.resource}${local.separator}${result}"]
}
#### Creating Random digits
resource "random_string" "random_digits" {
  count   = var.gen_no_of_names
  length  = var.random_alphanumeric_len
  special = var.special
  upper   = var.upper
  numeric = var.number
}
variable "app" {
  description = "Name of the application, For ex: network, shared, ddp etc."
  type        = string
  validation {
    condition     = length(var.app) <= 6
    error_message = "The app name must be less than or equal to 6 characters."
  }
}
variable "env" {
  description = "Name of the environment example: for development env it should be 'd', prod env should be 'p', testing env should be 'q' and staging env should be's'."
  type        = string
  validation {
    condition     = contains(["d", "p", "q", "s"], var.env)
    error_message = "env must be one of 'd', 'p', 'q', 's'"
  }
}
variable "resource" {
  description = "Name of the resource, for ex: eks,efs,ecr. The length of the resource name should not exceed more than 8"
  type        = string  
}
variable "special" {
  description = "Include special characters in the result. These are !@#$%&*()-_=+[]{}<>:?. Default value is false"
  type        = bool
  default     = false
}
variable "upper" {
  description = "Include uppercase alphabet characters in the result. Default value is false"
  type        = bool
  default     = false
}
variable "number" {
  description = "Include number in the result. Default value is true"
  type        = bool
  default     = true
}
variable "gen_no_of_names" {
  description = "Generate n number of names. Default value is 1"
  type        = number
  default     = 1
}
variable "random_alphanumeric_len" {
  description = "The length of random alphanumeri string desired. The min value for length is 1  and max is 4."
  type        = number
  default     = 4
  validation {
    condition     = var.random_alphanumeric_len >= 1 && var.random_alphanumeric_len <= 4
    error_message = "The length must be between 1 and 4."
  }
}
output "naming_tag" {
  description = "list of names of the Naming tag"
  value       = local.name
}
#$ cat Terraform.tfvars
#team = "dummy@gmail.com"
#env = "d"
#app = "fkart"
#createdBy = "ratnakar"
#resource = "ec2"