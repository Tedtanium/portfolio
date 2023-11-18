# Use of this file makes it so that very little needs to be configured per-instance launched.

variable "instance_type" {
  type        = string
  default     = "m5.large"
  description = "AWS instance type"
}
variable "Env" {
  type        = string
  default     = "REDACTED"
  description = "Set the environment tag"
}

variable "hostname" {
  type = string
}
variable "logical_component" {
  type = string
}
variable "service" {
  type = string
}
variable "service_component" {
  type = string
}
variable "security_groups" {
  type = list(string)
}

variable "ebs_size" {
  type = number
}

variable "subnet" {
  type    = string
  default = null
}


variable "root_size" {
  type     = number
  default  = 20
  nullable = false
}

variable "iam_instance_profile" {
  type     = string
  default  = "REDACTED"
  nullable = false
}

variable "ami" {
  type    = string
  nullable = false
}
