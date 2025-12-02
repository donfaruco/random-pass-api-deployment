variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_access_key" {
  type        = string
}

variable "aws_secret_key" {
  type        = string
}

variable "ami_id" {
  type        = string
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "instance_name" {
  type        = string
}

variable "key_name" {
  type        = string
}

variable "public_key_path" {
  type        = string
}

variable "private_key_path" {
  type        = string
}

variable "ssh_user" {
  type        = string
}

