variable "bucket_name" {
  description = "Name of the Bucket to store website content"
  type        = string
  default     = "website-bucket"
}

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-west-2"
}

variable "website_source_path" {
  description = "Path to the website index.html file"
  type        = string
  default     = "../../website/index.html"
}
