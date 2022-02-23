resource "aws_budgets_budget" "budget" {
  count             = var.create_budget_notification ? 1 : 0
  account_id        = var.budget_account_id
  name              = var.budget_name
  budget_type       = var.budget_type
  limit_amount      = var.budget_limit_amount
  limit_unit        = var.budget_limit_unit
  time_period_end   = var.budget_time_period_end
  time_period_start = var.budget_time_period_start
  time_unit         = var.budget_time_unit
  cost_filters      = var.budget_cost_filters

  dynamic "cost_types" {
    for_each = var.budget_cost_types == null ? [] : [1]
    content {
      include_credit             = var.budget_cost_types.include_credit
      include_discount           = var.budget_cost_types.include_discount
      include_other_subscription = var.budget_cost_types.include_other_subscription
      include_recurring          = var.budget_cost_types.include_recurring
      include_refund             = var.budget_cost_types.include_refund
      include_subscription       = var.budget_cost_types.include_subscription
      include_support            = var.budget_cost_types.include_support
      include_tax                = var.budget_cost_types.include_tax
      include_upfront            = var.budget_cost_types.include_upfront
      use_amortized              = var.budget_cost_types.use_amortized
      use_blended                = var.budget_cost_types.use_blended
    }
  }

  dynamic "notification" {
    for_each = var.budget_notifications
    content {
      comparison_operator        = notification.value["comparison_operator"]
      threshold                  = notification.value["threshold"]
      threshold_type             = notification.value["threshold_type"]
      notification_type          = notification.value["notification_type"]
      subscriber_email_addresses = notification.value["subscriber_email_addresses"]
      subscriber_sns_topic_arns  = notification.value["subscriber_sns_topic_arns"]
    }
  }
}