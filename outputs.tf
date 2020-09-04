output "acm_certificate" {
  value       = aws_acm_certificate.certificate
  description = <<-EOD
    AWS ACM Certificate object.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate#attributes-reference
    for more details
  EOD
}

output "acm_certificate_validation" {
  value       = aws_acm_certificate_validation.certificate_validation
  description = <<-EOD
    AWS ACM Certificate Validation object.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation#attributes-reference
    for more details
  EOD
}

output "budget" {
  value       = aws_budgets_budget.budget
  description = <<-EOD
    AWS Budgets object.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget#attributes-reference
    for more details
  EOD
}

output "cloudfront_distribution" {
  value       = aws_cloudfront_distribution.s3_distribution
  description = <<-EOD
    AWS CloudFront distribution object.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#attribute-reference
    for more details
  EOD
}

output "cloudfront_origin_access_identity" {
  value       = aws_cloudfront_origin_access_identity.origin_access_identity
  description = <<-EOD
    AWS CloudFront origin access identity object.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_origin_access_identity#attribute-reference
    for more details
  EOD
}

output "resource_group" {
  value       = aws_resourcegroups_group.website
  description = <<-EOD
    AWS Resource Group object.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/resourcegroups_group#attributes-reference
    for more details
  EOD
}

output "route53_hosted_zone" {
  value       = aws_route53_zone.hosted_zone
  description = <<-EOD
    AWS Route53 Hosted Zone object.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone#attributes-reference
    for more details
  EOD
}

output "route53_cname_record" {
  value       = aws_route53_record.cname_record
  description = <<-EOD
    AWS Route53 CNAME Record object for DNS validation.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#attributes-reference
    for more details
  EOD
}

output "route53_root_domain_record" {
  value       = aws_route53_record.root_domain
  description = <<-EOD
    AWS Route53 A Record object for root domain.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#attributes-reference
    for more details
  EOD
}

output "route53_sub_domain_record" {
  value       = aws_route53_record.sub_domain
  description = <<-EOD
    AWS Route53 A Record object for the www sub-domain.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record#attributes-reference
    for more details
  EOD
}

output "s3_bucket_root_domain" {
  value       = aws_s3_bucket.root_domain
  description = <<-EOD
    AWS S3 bucket for the root domain.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#attributes-reference
    for more details
  EOD
}

output "s3_bucket_sub_domain" {
  value       = aws_s3_bucket.sub_domain
  description = <<-EOD
    AWS S3 bucket for the www sub-domain.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#attributes-reference
    for more details
  EOD
}

output "s3_bucket_policy_root_domain" {
  value       = aws_s3_bucket_policy.root_domain
  description = <<-EOD
    AWS S3 bucket policy object for the root domain.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy#argument-reference
    for more details
  EOD
}

output "s3_bucket_policy_sub_domain" {
  value       = aws_s3_bucket_policy.sub_domain
  description = <<-EOD
    AWS S3 bucket policy object for the www sub-domain.
    See https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy#argument-reference
    for more details
  EOD
}