variable "aws_region" { type = string; default = "ap-south-1" }
variable "project"    { type = string; default = "Slash" }
variable "env"        { type = string; default = "Dev" }
variable "instance_type" { type = string; default = "t3.micro" }
variable "subnet_id"  { type = string }
variable "security_group_ids" { type = list(string) }
variable "instance_count" { type = number; default = 1 }
variable "name_prefix" { type = string; default = "slash-web" }
variable "ansible_enabled" { type = bool; default = true }
variable "key_name" { type = string; default = null }
