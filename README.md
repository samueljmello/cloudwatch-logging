# Cloudwatch Logging
Within CloudWatch exists a feature called LogGroups which, when combined with CloudWatch Agent, can pipe logs to custom groups, allowing for a single-pane-of-glass for log analysis and alerting.

This POC creates the following resources in order to demo the functionality:

1. Security Group provisioned in default VPC allowing port 22 and 80 for a provided IP address.
2. IAM Role using two managed IAM policies: 
   1. test2
   2. test1
3. EC2 Instance Profile using the aforementioned IAM Role.
4. EC2 Instance using Security Group and IAM Instance Profile.
   1. Provisioned with Apache
   2. Provisioned with CloudWatch Agent

## Deploying
The process of deploying uses the AWS CLI with the following commands.

First, a CloudFormation package must be created with:

```
aws cloudformation package \
    --profile "<profile>" \
    --s3-bucket "<s3-bucket>" \
    --template-file "<template-file>" \
    --output-template-file "<output-file>"
```

And lastly, the CloudFormation deployment must be triggered with:

```
aws cloudformation deploy \
    --profile "<profile>" \
    --template-file "<output-file>" \
    --stack-name "<stack-name"> \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides "<override-item>"
```

For both commands, you must replace the values above with values related to your environment. For parameter overrides, reference the template file "parameters" definition.

## Post-Deployment
Because two "associations" are used, a race condition exists. You will need to:

1. Visit [AWS Systems Manager State Manager](https://console.aws.amazon.com/systems-manager/state-manager) and validate the 'CloudWatchAgentConfig' association successfully completed.
2. If it is in a failed status:
   1. Click the assoication ID to open the association.
   2. Click "apply association now" to execute the comand, then confirm when prompted.

## Custom Deployment
Here are the commands I used for copy & paste purposes (there are no sensitive values in here, and potentially sensitive values were ref'd by environment variables that I exported prior to running these).

Package:
```aws cloudformation package --profile "isengard" --s3-bucket "${AWS_S3_BUCKET}" --template-file "template.yaml" --output-template-file "output/plan"```

Deploy:
```aws cloudformation deploy --profile "isengard" --template-file "output/plan" --stack-name "cloudwatch-logging" --capabilities CAPABILITY_IAM --parameter-overrides "MyIp=${AWS_MY_IP}" "PemKey=mello"```