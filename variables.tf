variable "instance_type" {
  description = "Type of EC2 instance to use"
  default     = "t2.micro"
  type        = string
}

variable "tags" {
  description = "Tags for instances"
  type        = map
  default     = {}
}

variable "aws_region" {
  type        = string
  default     = "us-east-2"
  description = "AWS region for all resources"
}

variable "tfc_aws_dynamic_credentials" {
  description = "Object containing AWS dynamic credentials configuration"
  type = object({
    default = object({
      shared_config_file = string
    }) 
    aliases = map(object({
      shared_config_file = string
    }))
  })
}
