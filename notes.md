# CloudWatch Notes

## Metrics Publishing
Data points published at specific intervals use the following rules for availability before aggregation:
 - 60 seconds, 15 days
 - 300 seconds, 63 days
 - 1 hour, 455 days

You are also allowed to namespace your metrics, with the exception of the "AWS/" namespace which is reserved.

Alarms have actions.

Event rules can also be used to define actions for Alarms.

## Log Groups
Log groups together related log streams, and control ACL, retention, etc.

Installation can be:
- manual
- script
- systems manager

The break down of your log streams is up to you. You could implement a stream within a group for each EC2 instance that reports to it.

It can take several minutes for custom metric filters to display in the metrics area.

## Pricing

https://aws.amazon.com/cloudwatch/pricing/