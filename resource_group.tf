resource "aws_resourcegroups_group" "website" {
  count    = var.create_resource_group ? 1 : 0
  provider = aws.tf-resource-group
  name     = "${var.root_domain_name}-resource-group"

  resource_query {
    query = <<JSON
{
  "ResourceTypeFilters": [
    "AWS::CertificateManager::Certificate",
    "AWS::CloudFront::Distribution",
    "AWS::Route53::Domain",
    "AWS::Route53::HostedZone",
    "AWS::S3::Bucket"
  ],
  "TagFilters": [
    {
      "Key": "Name",
      "Values": ["${var.root_domain_name}"]
    }
  ]
}
JSON
  }

  tags = {
    Name = var.root_domain_name
  }
}