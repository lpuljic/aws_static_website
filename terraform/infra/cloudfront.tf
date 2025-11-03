/*
Data sources for managed CloudFront policies
Using managed policies for better performance, security, and maintainability
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/cloudfront_cache_policy
*/
data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized" # Optimizes caching for static content, improving performance and reducing origin requests
}

data "aws_cloudfront_origin_request_policy" "cors_s3_origin" {
  name = "Managed-CORS-S3Origin" # Forwards appropriate headers to S3 for CORS and other origin interactions
}

# Origin Access Control (OAC) to restrict access to S3 bucket via CloudFront only
resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "OAC for website"
  description                       = "Origin Access Control for Lano Puljic Website"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always" # this will always sign requests
  signing_protocol                  = "sigv4"
}

# CloudFront distribution for serving the website
resource "aws_cloudfront_distribution" "website" {
  comment             = "This is Lano Puljic Website"
  enabled             = true
  is_ipv6_enabled     = true
  http_version        = "http2and3"  # Enable HTTP2/3 for better performance.
  default_root_object = "index.html" # When you hit the root of the URL it will respond back with index.html
  price_class         = "PriceClass_100"

  # Origin configuration for S3 bucket
  origin {
    domain_name              = aws_s3_bucket.website_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
    origin_id                = "S3-website"

  }
  /*
  Default cache behavior for the distribution
  Updated to use managed cache and origin request policies for better performance and security
  Replaced forwarded_values with cache_policy and origin_request_policy to leverage AWS-managed optimizations
  TTL values are managed by the cache policy and should not be overridden here
  */
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-website"

    cache_policy_id          = data.aws_cloudfront_cache_policy.caching_optimized.id
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.cors_s3_origin.id

    viewer_protocol_policy = "redirect-to-https"
  }

  # Geo-restrictions (none applied)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Custom error responses
  # Redirects 404 errors to a custom 404.html page if it exists in the S3 bucket
  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 300 # Cache error responses for 5 minutes
  }

  # SSL certificate configuration (using default CloudFront certificate)
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
