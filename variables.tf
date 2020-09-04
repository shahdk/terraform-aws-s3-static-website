locals {
  s3_origin_id = "S3-${var.root_domain_name}"
}

variable "root_domain_name" {
  type        = string
  description = <<-EOD
    The domain name for the static website. It will be used to create the S3 buckets and certificate for CloudFront
  EOD
}

variable "s3_website_index_doc" {
  type        = string
  description = "Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders"
  default     = "index.html"
}

variable "create_resource_group" {
  type        = bool
  description = "Flag to enable/disable creation of the resource group"
  default     = true
}

variable "create_budget_notification" {
  type        = bool
  description = "Flag to enable/disable creation of budget notification"
  default     = true
}

variable "budget_account_id" {
  type        = string
  description = <<-EOD
    (Optional) The ID of the target account for budget. Will use current user's account_id by default if omitted
  EOD
  default     = null
}

variable "budget_name" {
  type        = string
  description = "(Optional) The name of a budget. Unique within accounts."
  default     = null
}

variable "budget_type" {
  type        = string
  description = "(Required) Whether this budget tracks monetary cost or usage."
  default     = "COST"
}

variable "budget_limit_amount" {
  type        = string
  description = "(Required) The amount of cost or usage being measured for a budget."
  default     = ""
}

variable "budget_limit_unit" {
  type        = string
  description = <<-EOD
    (Required) The unit of measurement used for the budget forecast, actual spend, or budget threshold,
    such as dollars or GB. See [Spend](http://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/data-type-spend.html)
    documentation.
  EOD
  default     = ""
}

variable "budget_time_period_end" {
  type        = string
  description = <<-EOD
    (Optional) The end of the time period covered by the budget. There are no restrictions on the end date.
    Format: `2017-01-01_12:00`.
  EOD
  default     = null
}

variable "budget_time_period_start" {
  type        = string
  description = <<-EOD
    (Required) The start of the time period covered by the budget. The start date must come before the end date.
    Format: `2017-01-01_12:00`.
  EOD
  default     = "2020-09-01_00:00"
}

variable "budget_time_unit" {
  type        = string
  description = <<-EOD
    (Required) The length of time until a budget resets the actual and forecasted spend.
    Valid values: MONTHLY, QUARTERLY, ANNUALLY.
  EOD
  default     = "MONTHLY"
}

variable "budget_cost_filters" {
  type        = map(string)
  description = <<-EOD
    (Optional) Map of CostFilters key/value pairs to apply to the budget.
    TF Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget#CostFilters
    AWS Docs: https://docs.aws.amazon.com/awsaccountbilling/latest/aboutv2/billing-what-is.html
  EOD
  default     = null
}

variable "budget_cost_types" {
  type = object({
    include_credit             = bool
    include_discount           = bool
    include_other_subscription = bool
    include_recurring          = bool
    include_refund             = bool
    include_subscription       = bool
    include_support            = bool
    include_tax                = bool
    include_upfront            = bool
    use_amortized              = bool
    use_blended                = bool
  })
  description = <<-EOD
    (Optional) Object containing CostTypes The types of cost included in a budget, such as tax and subscriptions.
    TF Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget#CostTypes
    AWS Docs: https://docs.aws.amazon.com/aws-cost-management/latest/APIReference/API_budgets_CostTypes.html
  EOD
  default     = null
}

variable "budget_notifications" {
  type = list(object({
    comparison_operator        = string
    threshold                  = number
    threshold_type             = string
    notification_type          = string
    subscriber_email_addresses = list(string)
    subscriber_sns_topic_arns  = list(string)
  }))
  description = <<-EOD
    (Optional) List of Object containing Budget Notifications, ie, you can create multiple ways to notify
    See: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/budgets_budget#BudgetNotification
  EOD
  default     = []
}

variable "cf_min_cache_ttl" {
  type        = number
  description = <<-EOD
    (Optional) - The minimum amount of time that you want objects to stay in CloudFront caches before
    CloudFront queries your origin to see whether the object has been updated. Defaults to 0 seconds.
  EOD
  default     = 0
}

variable "cf_max_cache_ttl" {
  type        = number
  description = <<-EOD
    (Optional) - The maximum amount of time (in seconds) that an object is in a CloudFront cache before
    CloudFront forwards another request to your origin to determine whether the object has been updated.
    Only effective in the presence of Cache-Control max-age, Cache-Control s-maxage, and Expires headers.
    Defaults to 1 day.
  EOD
  default     = 86400
}

variable "cf_default_cache_ttl" {
  type        = number
  description = <<-EOD
    (Optional) - The default amount of time (in seconds) that an object is in a CloudFront cache before
    CloudFront forwards another request in the absence of an Cache-Control max-age or Expires header.
    Defaults to 1 hour.
  EOD
  default     = 3600
}

variable "cf_price_class" {
  type        = string
  description = <<-EOD
    (Optional) - The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100
  EOD
  default     = "PriceClass_All"
}

variable "cf_cache_allowed_methods" {
  type        = list(string)
  description = <<-EOD
    (Required) - Controls which HTTP methods CloudFront processes and forwards to your Amazon S3 bucket or
    your custom origin.
  EOD
  default     = ["GET", "HEAD"]
}

variable "cf_cache_cached_methods" {
  type        = list(string)
  description = <<-EOD
    (Required) - Controls whether CloudFront caches the response to requests using the specified HTTP methods.
  EOD
  default     = ["GET", "HEAD"]
}

variable "cf_cache_compress" {
  type        = bool
  description = <<-EOD
    (Optional) - Whether you want CloudFront to automatically compress content for web requests that include
    Accept-Encoding: gzip in the request header.
  EOD
  default     = false
}

variable "cf_cache_field_level_encryption_id" {
  type        = string
  description = "(Optional) - Field level encryption configuration ID"
  default     = null
}

variable "cf_cache_forwarded_values" {
  type = object({
    cookies = object({
      forward           = string
      whitelisted_names = list(string)
    })
    headers                 = set(string)
    query_string            = bool
    query_string_cache_keys = list(string)
  })
  description = <<-EOD
    (Required) - The forwarded values configuration that specifies how CloudFront handles query strings,
    cookies and headers.
    TF Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#forwarded-values-arguments
  EOD
  default = {
    cookies = {
      forward           = "none"
      whitelisted_names = []
    }
    headers                 = []
    query_string            = false
    query_string_cache_keys = []
  }
}

variable "cf_cache_lambda_function_association" {
  type = list(object({
    event_type   = string
    lambda_arn   = string
    include_body = bool
  }))
  description = <<-EOD
    (Optional) - A config block that triggers a lambda function with specific actions. maximum 4.
    TF Docs: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution#lambda_function_association
  EOD
  default     = []
}

variable "cf_cache_smooth_streaming" {
  type        = bool
  description = <<-EOD
    (Optional) - Indicates whether you want to distribute media files in Microsoft Smooth Streaming format
    using the origin that is associated with this cache behavior.
  EOD
  default     = null
}

variable "cf_cache_trusted_signers" {
  type        = list(string)
  description = <<-EOD
    (Optional) - List of AWS account IDs (or self) that you want to allow to create signed URLs for private content.
    See [CloudFront Docs](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/private-content-trusted-signers.html)
    for more information about this feature.
  EOD
  default     = null
}

variable "cf_cache_viewer_protocol_policy" {
  type        = string
  description = <<-EOD
    (Required) - Use this element to specify the protocol that users can use to access the files in the origin
    specified by TargetOriginId.
    One of allow-all, https-only, or redirect-to-https.
  EOD
  default     = "redirect-to-https"
}

variable "cf_cache_geo_restriction" {
  type = object({
    locations        = set(string)
    restriction_type = string
  })
  description = <<-EOD
    (Required) - The restriction configuration for this distribution (maximum one).
    The `restrictions` sub-resource takes another single sub-resource named `geo_restriction`
    The arguments of geo_restriction are:
    - locations (Optional) : The ISO 3166-1-alpha-2 codes for which you want CloudFront either to distribute your
        content (whitelist) or not distribute your content (blacklist).
    - restriction_type (Required) : The method that you want to use to restrict distribution of your content
      by country: none, whitelist, or blacklist.
  EOD
  default = {
    locations        = []
    restriction_type = "none"
  }
}

variable "cf_viewer_certificate_min_protocol" {
  type        = string
  description = <<-EOD
    The minimum version of the SSL protocol that you want CloudFront to use for HTTPS connections.
    Can only be set if cloudfront_default_certificate = false.
    One of TLSv1, TLSv1_2016, TLSv1.1_2016, TLSv1.2_2018 or TLSv1.2_2019.
    NOTE: If you are using a custom certificate (specified with acm_certificate_arn or iam_certificate_id), and
    have specified sni-only in ssl_support_method, TLSv1 or later must be specified.
  EOD
  default     = "TLSv1.1_2016"
}

variable "cf_web_acl_id" {
  type        = string
  description = <<-EOD
    (Optional) - If you're using AWS WAF to filter CloudFront requests, the Id of the AWS WAF web ACL that is
    associated with the distribution. The WAF Web ACL must exist in the WAF Global (CloudFront) region and
    the credentials configuring this argument must have `waf:GetWebACL` permissions assigned.
    If using WAFv2, provide the ARN of the web ACL.
  EOD
  default     = null
}

variable "cf_retain_on_delete" {
  type        = bool
  description = <<-EOD
    (Optional) - Disables the distribution instead of deleting it when destroying the resource through Terraform.
    If this is set, the distribution needs to be deleted manually afterwards. Default: `false`
  EOD
  default     = false
}

variable "cf_wait_for_deployment" {
  type        = bool
  description = <<-EOD
    (Optional) - If enabled, the resource will wait for the distribution status to change from `InProgress`
    to `Deployed`. Setting this to `false` will skip the process. Default: `true`.
  EOD
  default     = true
}