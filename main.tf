terraform {
  # Require Terraform version 0.13.x (recommended)
  required_version = "~> 0.13.0"

  # Require the latest 2.x version of the New Relic provider
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "~> 2.21"
    }
  }
}

provider "newrelic" {
  # Your New Relic account ID. Or use the environment variable NEW_RELIC_ACCOUNT_ID
  # account_id = "<Your New Relic account ID>"
  # Your New Relic user key. Or use the environment variable NEW_RELIC_API_KEY
  # api_key = "<Your User API key>"
  # US or EU (defaults to US)
  region = "US"
}

data "newrelic_entity" "test_api_dev" {
  name = "test-api-dev" # Must be an exact match to your application name in New Relic
  domain = "APM" # or BROWSER, INFRA, MOBILE, SYNTH, depending on your entity's domain
  type = "APPLICATION"
}

resource "newrelic_alert_policy" "test_api_dev_alerts" {
  name = "test-api-dev-alerts"
}

# Response time
resource "newrelic_alert_condition" "test_api_dev_response_time_web" {
  policy_id       = newrelic_alert_policy.test_api_dev_alerts.id
  name            = "High Response Time (Web) - ${data.newrelic_entity.test_api_dev.name}"
  type            = "apm_app_metric"
  entities        = [data.newrelic_entity.test_api_dev.application_id]
  metric          = "response_time_web"
  condition_scope = "application"

  # Define a critical alert threshold that will trigger after 5 minutes above a 0.7 response time.
  term {
    duration      = 5
    operator      = "above"
    threshold     = "0.7"
    priority      = "critical"
    time_function = "all"
  }

  # Define a warning alert threshold that will trigger after 5 minutes above a 0.5 response time.
  term {
    duration      = 5
    operator      = "above"
    threshold     = "0.5"
    priority      = "warning"
    time_function = "all"
  }
}

# Error percentage
resource "newrelic_alert_condition" "test_api_dev_error_percentage" {
  policy_id       = newrelic_alert_policy.test_api_dev_alerts.id
  name            = "High Error Percentage"
  type            = "apm_app_metric"
  entities        = [data.newrelic_entity.test_api_dev.application_id]
  metric          = "error_percentage"
  condition_scope = "application"

  # Define a critical alert threshold that will trigger after 5 minutes above a 30% error rate.
  term {
    duration      = 5
    operator      = "above"
    threshold     = "30"
    priority      = "critical"
    time_function = "all"
  }

  # Define a warning alert threshold that will trigger after 5 minutes above a 25% error rate.
  term {
    duration      = 5
    operator      = "above"
    threshold     = "25"
    priority      = "warning"
    time_function = "all"
  }
}

# Apdex
resource "newrelic_alert_condition" "test_api_dev_apdex" {
  policy_id       = newrelic_alert_policy.test_api_dev_alerts.id
  name            = "High Error Percentage"
  type            = "apm_app_metric"
  entities        = [data.newrelic_entity.test_api_dev.application_id]
  metric          = "apdex"
  condition_scope = "application"

  # Define a critical alert threshold that will trigger after 5 minutes below 0.7 apodex.
  term {
    duration      = 5
    operator      = "below"
    threshold     = "0.7"
    priority      = "critical"
    time_function = "all"
  }

  # Define a warning alert threshold that will trigger after 5 minutes below 0.85 apodex.
  term {
    duration      = 5
    operator      = "below"
    threshold     = "0.85"
    priority      = "warning"
    time_function = "all"
  }
}

# Slack notification channel
resource "newrelic_alert_channel" "slack_notification" {
  name = "slack-notification"
  type = "slack"

  config {
    # Use the URL provided in your New Relic Slack integration
    url     = "Slack Hook URL Here..."
    channel = "channel-name"
  }
}

resource "newrelic_alert_policy_channel" "test_api_dev_alerts_config" {
  policy_id   = newrelic_alert_policy.test_api_dev_alerts.id
  channel_ids = [newrelic_alert_channel.slack_notification.id]
}
