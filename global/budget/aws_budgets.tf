resource "aws_budgets_budget" "org_budget" {
  name         = "organization-wide-budget"
  budget_type  = "COST"
  limit_amount = "1000"
  limit_unit   = "USD" # Budget is set in USD
  time_unit    = "MONTHLY"

  cost_filters = {
    LinkedAccount = ["*"]  # Applies to all AWS accounts in the organization
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = ["itmc-aws-root@adesso-service.com", "bekir.kocabas@adesso.de"]
    subscriber_sns_topic_arns  = [aws_sns_topic.budget_alerts.arn]
  }
}

resource "aws_sns_topic" "budget_alerts" {
  name = "budget-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription_root" {
  topic_arn = aws_sns_topic.budget_alerts.arn
  protocol  = "email"
  endpoint  = "itmc-aws-root@adesso-service.com"
}

resource "aws_sns_topic_subscription" "email_subscription_admin1" {
  topic_arn = aws_sns_topic.budget_alerts.arn
  protocol  = "email"
  endpoint  = "bekir.kocabas@adesso.de"
}
