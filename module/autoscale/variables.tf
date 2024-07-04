variable "ami_id" {
  description = "The AMI ID for the instances."
  type        = string
  default     = "ami-0c68b55d1c875067e"
}

variable "instance_type" {
  description = "The instance type for the instances."
  type        = string
  default     = "t2.micro"
}

variable "cidr_block_vpc" {
  default = "10.0.0.0/16"
}

variable "cidr_block_subnet" {
  default = "10.0.1.0/24"
}


variable "have_load_balancer" {
  description = "True lb deployed and false lb not deployed."
  type        = bool
  default     = false
}

variable "date" {
  description = "setting a date for more descriptive name of ressources"
}
variable "desired_capacity_AC" {
    type = any
    default = {
        "Prod" = {
            desired_capacity = 6
            max_size         = 12
            min_size         = 6
        }
        "Dev" = {
            desired_capacity = 1
            max_size         = 1
            min_size         = 1
        }
    }
}

variable "subnet_id" {
  description = "Setting the subnet id like : aws_subnet.toto_subnet.id"
  default = ""
}

variable "vpc_id" {
  description = "setting the vpc id like : aws_vpc.toto_vpc.id"
}

variable "environment" {
  description = "The environment to deploy (Prod or Dev)."
  type        = string
  default     = "Prod"
}

variable "port_number" {
  description = "number of port for security group"
  type        = number
  default     = 80
}