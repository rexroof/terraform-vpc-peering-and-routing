variable "request_region" {
  default     = "us-east-1"
  description = "aws region requesting the vpc peering connection"
}

variable "request_vpc" {
  description = "the requesting vpc id"
}

variable "request_routes" {
  type        = "list"
  description = "list of route tables to update on the requesting vpc"
}

variable "accept_region" {
  default     = "us-west-2"
  description = "aws region accepting the vpc peering connection"
}

variable "accept_vpc" {
  description = "the accepting vpc id"
}

variable "accept_routes" {
  type        = "list"
  description = "list of route tables to update on the accepting vpc"
}
