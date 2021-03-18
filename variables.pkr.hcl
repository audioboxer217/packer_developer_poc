variable "rhsm_user" {
  type =  string
}

variable "rhsm_pass" {
  type =  string
  sensitive = true
}

variable "rhsm_pool" {
  type =  string
}

variable "system_user" {
  type = string
  default = "packer"
}

variable "system_pass" {
  type = string
  default = "packer"
  sensitive = true
}