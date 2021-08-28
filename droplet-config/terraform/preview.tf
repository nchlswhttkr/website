resource "aws_s3_bucket" "preview" {
  bucket = "preview.nicholas.cloud"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_object" "bucket_documents" {
  for_each = toset(["index.html", "robots.txt"])
  
  bucket = aws_s3_bucket.preview.bucket
  key = each.key
  source = "./preview-bucket-files/${each.key}"
  etag = filemd5("./preview-bucket-files/${each.key}")
}

resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.preview.bucket
}

data "aws_iam_policy_document" "public_bucket_access" {
  version = "2012-10-17"
  statement {
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.preview.arn}/*"]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "preview_bucket_policy" {
  bucket = aws_s3_bucket.preview.bucket
  policy = data.aws_iam_policy_document.public_bucket_access.json
  depends_on = [
    aws_s3_bucket_public_access_block.public_access_block
  ]
}

resource "aws_iam_user" "preview" {
  name = "PreviewManager"
}

resource "aws_iam_access_key" "preview_credentials" {
  user = aws_iam_user.preview.name
}

data "aws_iam_policy_document" "manage_preview_objects" {
  version = "2012-10-17"
  statement {
    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.preview.arn,
      "${aws_s3_bucket.preview.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "manage_preview_objects" {
  name   = "ManagePreviewObjects"
  policy = data.aws_iam_policy_document.manage_preview_objects.json
}

resource "aws_iam_user_policy_attachment" "manage_preview_objects" {
  user       = aws_iam_user.preview.name
  policy_arn = aws_iam_policy.manage_preview_objects.arn
}

resource "aws_acm_certificate" "preview_certificate" {
  provider = aws.us_tirefire_1

  domain_name = "preview.nicholas.cloud"
  validation_method = "DNS"
}

resource "aws_acm_certificate_validation" "preview_certificate" {
  provider = aws.us_tirefire_1

  certificate_arn = aws_acm_certificate.preview_certificate.arn
}

locals {
  preview_bucket_origin_id = aws_s3_bucket.preview.bucket
}

resource "aws_cloudfront_distribution" "preview_distribution" {
  origin {
    domain_name = aws_s3_bucket.preview.website_endpoint
    origin_id   = local.preview_bucket_origin_id
    custom_origin_config {
      http_port = 80
      https_port = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols = ["TLSv1.2"]
    }
  }

  enabled = true
  aliases = ["preview.nicholas.cloud"]

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate.preview_certificate.arn
    ssl_support_method  = "sni-only"
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress               = true
    target_origin_id       = local.preview_bucket_origin_id
    viewer_protocol_policy = "redirect-to-https"
    forwarded_values {
      cookies {
        forward = "none"
      }
      query_string = false
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
