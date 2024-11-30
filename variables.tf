variable "aws_eks_cluster_name" {
  description = "eks cluster name"
  type        = string
  default     = null
}

variable "region" {
  description = "region for eks cluster"
  type = string
}