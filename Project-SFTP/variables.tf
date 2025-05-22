variable "region" {
  description = "The AWS region"
  default     = "us-east-1"
}

variable "sftp_users" {
  type = map(object({
    logical_directory_mappings = list(object({
      source_directory = string
      user_directory   = string
    }))
    ssh_public_key_files = list(string)
  }))
  description = "A map of SFTP users and their SSH public keys"
}

variable "sftp_users" {
  type        = list(string)
  description = "A list of sftp users"

}

variable "vpc_name" {
  type = string
}

variable "vpc_tags" {
  description = "Tags to filter the VPC"
  type        = map(string)
  default     = {}

}

variable "private_subnet_tags" {
  description = "Tags to filter the VPC"
  type        = map(string)
  default     = {}

}

variable "public_subnet_tags" {
  description = "Tags to filter the VPC"
  type        = map(string)
  default     = {}

}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "aws_security_group_tranfer" {
  type    = string
  default = ""
}

variable "Service" {
  type    = string
  default = "acsp-aml-data-ingestion"

}

variable "aws_security_group" {
  type    = string
  default = ""

}

variable "aws_transfer_server" {
  type    = string
  default = ""

}