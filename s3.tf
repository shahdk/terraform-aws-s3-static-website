# Public S3 bucket with the domain as the bucket name and static site hosting enabled
resource "aws_s3_bucket" "root_domain" {
  provider      = aws.tf-s3
  bucket        = var.root_domain_name
  force_destroy = true
  acl           = "public-read"
  website {
    index_document = var.s3_website_index_doc
  }
  tags = {
    Name = var.root_domain_name
  }
}

# Private S3 bucket with www sub-domain as the bucket name and redirect to the domain bucket
resource "aws_s3_bucket" "sub_domain" {
  provider      = aws.tf-s3
  bucket        = "www.${var.root_domain_name}"
  force_destroy = true
  acl           = "private"
  website {
    redirect_all_requests_to = var.root_domain_name
  }
  tags = {
    Name = var.root_domain_name
  }
}

# S3 bucket policy for the domain bucket to allow public read and CloudFront access
data "aws_iam_policy_document" "root_domain" {
  provider = aws.tf-s3
  statement {
    sid       = "PublicCloudFront"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.root_domain.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

# Attach bucket policy to domain bucket
resource "aws_s3_bucket_policy" "root_domain" {
  provider = aws.tf-s3
  bucket   = aws_s3_bucket.root_domain.id
  policy   = data.aws_iam_policy_document.root_domain.json
}


# S3 bucket policy for the www sub-domain bucket to allow CloudFront access
data "aws_iam_policy_document" "sub_domain" {
  provider = aws.tf-s3
  policy_id = "PolicyForCloudFrontPrivateContent"
  statement {
    sid       = "PublicCloudFront"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.sub_domain.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn]
    }
  }
}

# Attach bucket policy to www sub-domain bucket
resource "aws_s3_bucket_policy" "sub_domain" {
  provider = aws.tf-s3
  bucket   = aws_s3_bucket.sub_domain.id
  policy   = data.aws_iam_policy_document.sub_domain.json
}