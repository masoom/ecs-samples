variable "vpc_id" {
  type        = string
  description = "The VPC id"
}

variable "private_subnets" {
  type        = list(string)
  description = "The private subnets in Prod VPC "
}

variable "certificate_arn" {
  type        = string
  description = "Optional ACM certificate "
}

variable "name" {
  type        = string
  description = "Variable name to be added as a Prefix for all resources"
  default     = "copyright-api"
}

variable "domain_name" {
  type        = string
  description = "Domain name of ACM status.services"
}

# Cachet Docker Image from the specified ECS repo
variable "image" {
  type        = string
  description = "The Docker Image name, to be pulled from AWS ECR."
  default     = "public.ecr.aws/i5k1d4j1/deloitte-copyright-api"
}

variable "tag" {
  type        = string
  description = "The public Docker Image tag from AWS ECR.."
  default     = "1.0"
}

variable "app_env" {
  type        = string
  description = "APP Environment (production or development)"
}

variable "container_port" {
  type        = number
  description = "Container port for Status Service"
  default     = 8000
}

variable "zone" {
  type        = string
  description = "The Route53 private Hosted Zone Name"
}

variable "ssl_policy" {
  type        = string
  description = "Recommended SSL Policy"
  default     = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
}

variable "private_zone" {
  type        = string
  description = "Toggle boolean value of true and false for hosted zone. For .org, use private_zone=true and for .com use private_zone=false"
  default     = "true"
}


variable "sns_topic_arn" {
  type        = string
  description = "SNS Topic ARN for Cloudwatch Alarm"
}

variable "bucket_name" {
  type        = string
  description = "BucketName for ELB Access Logs"
}