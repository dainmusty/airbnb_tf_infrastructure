
variable "ami_id" {
  type        = string
  default     = "ami-0f9d441b5d66d5f31"
  description = "instance ami used"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Instance type used"
}
