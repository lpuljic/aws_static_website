# Create S3 Bucket to store website content
resource "aws_s3_bucket" "website_bucket" {
  bucket        = "${var.bucket_name}-${random_string.this.id}"
  force_destroy = true
}

/*
We would want to enable versioning here so that we can rollback.
This will act as addition backup feature if required.
*/
resource "aws_s3_bucket_versioning" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Here we want to assure that object uploaded to this bucket are ownde by the bucket owner rather than the uploader.
resource "aws_s3_bucket_ownership_controls" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

/*
We want to block all public access, to prevent any leaks.
We will utilise Cloudfront to access the content of the bucket via OAC.
*/
resource "aws_s3_bucket_public_access_block" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# We would want to encrypt on rest here, however if this is just for test purpose this might not be required.
resource "aws_s3_bucket_server_side_encryption_configuration" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

/*
IAM policy document to allow CloudFront Origin Access Control(OAC) to access S3 bucket
OAC is the replacement for Origin Access Identity (OAI)
*/
data "aws_iam_policy_document" "allow_oac" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_bucket.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.website.arn]
    }
  }
}

# Attach the policy to the S3 bucket to allow CloudFront access
resource "aws_s3_bucket_policy" "website_bucket" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = data.aws_iam_policy_document.allow_oac.json
}
