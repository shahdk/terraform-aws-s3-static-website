resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  provider = aws.tf-cloudfront
  comment  = var.root_domain_name
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  provider = aws.tf-cloudfront

  origin {
    domain_name = aws_s3_bucket.root_domain.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  origin {
    domain_name = aws_s3_bucket.root_domain.bucket_regional_domain_name
    origin_id   = "S3-www.${var.root_domain_name}"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = var.s3_website_index_doc
  aliases             = [var.root_domain_name, "www.${var.root_domain_name}"]
  price_class         = var.cf_price_class

  default_cache_behavior {
    allowed_methods           = var.cf_cache_allowed_methods
    cached_methods            = var.cf_cache_cached_methods
    compress                  = var.cf_cache_compress
    default_ttl               = var.cf_default_cache_ttl
    field_level_encryption_id = var.cf_cache_field_level_encryption_id

    forwarded_values {
      cookies                 = var.cf_cache_forwarded_values.cookies
      headers                 = var.cf_cache_forwarded_values.headers
      query_string            = var.cf_cache_forwarded_values.query_string
      query_string_cache_keys = var.cf_cache_forwarded_values.query_string_cache_keys
    }

    dynamic "lambda_function_association" {
      for_each = var.cf_cache_lambda_function_association
      content {
        event_type   = lambda_function_association.value["event_type"]
        lambda_arn   = lambda_function_association.value["lambda_arn"]
        include_body = lambda_function_association.value["include_body"]
      }
    }

    max_ttl                = var.cf_max_cache_ttl
    min_ttl                = var.cf_min_cache_ttl
    smooth_streaming       = var.cf_cache_smooth_streaming
    target_origin_id       = local.s3_origin_id
    trusted_signers        = var.cf_cache_trusted_signers
    viewer_protocol_policy = var.cf_cache_viewer_protocol_policy
  }

  restrictions {
    geo_restriction {
      locations        = var.cf_cache_geo_restriction.locations
      restriction_type = var.cf_cache_geo_restriction.restriction_type
    }
  }

  tags = {
    Name = var.root_domain_name
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.certificate.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = var.cf_viewer_certificate_min_protocol
  }

  web_acl_id          = var.cf_web_acl_id
  retain_on_delete    = var.cf_retain_on_delete
  wait_for_deployment = var.cf_wait_for_deployment
}