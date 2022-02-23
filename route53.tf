# This is needed only if you want to use Route53 as your registrar and DNS resolver

# Create the hosted zone in Route53
# NOTE: if you bought the domain with Amazon, it already creates one for you. In that case import the existing one
# To import, go to your AWS Console > Route 53 > your domain > copy the hosted zone id
# Run ```terraform import aws_route53_zone.hosted_zone <<hosted zone id>>```
resource "aws_route53_zone" "hosted_zone" {
  name     = var.root_domain_name
  tags = {
    Name = var.root_domain_name
  }
}


# Creates the Route53 CName for the certificate manager's DNS validation
resource "aws_route53_record" "cname_record" {
  for_each = {
    for dvo in aws_acm_certificate.certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.hosted_zone.zone_id
}


# Creates A Record for the domain resolving to the cloudfront distribution
resource "aws_route53_record" "root_domain" {
  zone_id  = aws_route53_zone.hosted_zone.zone_id
  name     = var.root_domain_name
  type     = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

# Creates A Record for the www sub-domain resolving to the cloudfront distribution
resource "aws_route53_record" "sub_domain" {
  zone_id  = aws_route53_zone.hosted_zone.zone_id
  name     = "www.${var.root_domain_name}"
  type     = "A"

  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}