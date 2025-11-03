resource "aws_s3_object" "website_index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  source       = "../../website/index.html"
  content_type = "text/html"
  etag         = filemd5("../../website/index.html")
}

resource "aws_s3_object" "website_404" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "404.html"
  source       = "../../website/404.html"
  content_type = "text/html"
  etag         = filemd5("../../website/404.html")
}

