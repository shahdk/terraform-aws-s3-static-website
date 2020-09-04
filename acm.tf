# SSL Certificate for your domain
resource "aws_acm_certificate" "certificate" {
  provider                  = aws.tf-certificatemanager
  domain_name               = var.root_domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.root_domain_name}"]
  options {
    certificate_transparency_logging_preference = "ENABLED"
  }
  tags = {
    Name = var.root_domain_name
  }
}

# DNS validation with the Route53 DNS records
resource "aws_acm_certificate_validation" "certificate_validation" {
  provider                = aws.tf-certificatemanager
  certificate_arn         = aws_acm_certificate.certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cname_record : record.fqdn]
}