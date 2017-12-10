variable "zones" {
  description = "default aws deplyment zones"
  default = ["ap-southeast-2a", "ap-southeast-2b"]
}
variable "max_num" {
    description = "The number of instances to provision"
    default     = "1"
}
variable "min_num" {
    description = "The number of instances to provision"
    default     = "1"
}
variable "desired_num" {
    description = "The number of instances to provision"
    default     = "1"
}
variable "app_instance_type" {
    description = "The EC2 instance type to provision"
    default     = "t2.micro"
}
variable "vpc_cidr" {
    description = "The VPC CIDR"
    default     = "enter value vpc cidr"
}
variable "subnet" {
    description = "The EC2 instance type to provision"
    default     = ["enter value subnet zone a", "enter value subnet zone b"]
}
variable "vpc_id" {
    description = "The VPC ID"
    default     = "enter value vpc id"
}
variable "access_key" {
    description = "Add Access key"
    default = "enter value for access key"
}
variable "secret_key" {
    description = "Add secret_key"
    default = "enter value for secret key"
}

# Can be used if using custom ssh key
#variable "ssh_key" {
#    default = "cbatest"
#    description = "Add secret_key"
#}
