# Cloudwatch Logging
Within CloudWatch exists a feature called LogGroups which, when combined with CloudWatch Agent, can pipe logs to custom groups, allowing for a single-pane-of-glass for log analysis and alerting.

This POC creates the following resources in order to demo the functionality:

1. Security Group provisioned in default VPC allowing port 22 and 80 for a provided IP address.
2. IAM Role using two managed IAM policies: 
   1. CloudWatchAgentServerPolicy
   2. AmazonSSMManagedInstanceCore
3. CloudWatch LogGroups:
   1. apache/access
   2. apache/error
4. CloudWatch MetricFilters:
   1. GET
   2. PUT
   3. POST
   4. DELETE
   5. 404
   6. OTHER ERROR
5. CloudWatch Dashboard for Apache
   1. Request Type Counts
   2. Errors
6. EC2 Instance Profile using the aforementioned IAM Role.
7. EC2 Instance using Security Group and IAM Instance Profile.
8. Systems Manager Parameter:
   1. CloudWatch vonfiguration file.
9.  Systems Manager State Manager Document:
   2. Provisions CloudWatch Agent
   3. Installs & Configures HTTPD
   4. Configures CloudWatch Agent
10. Systems Manager Association for instance to document.

---

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

---

## Custom Deployment
Here are the commands I used for copy & paste purposes (there are no sensitive values in here, and potentially sensitive values were ref'd by environment variables that I exported prior to running these).

Export:
```
export AWS_S3_BUCKET="<bucketname>"
export AWS_MY_IP="<my-ip-address>"
export AWS_EC2_KEY="<key-name>"
```

Package:
```aws cloudformation package --s3-bucket "${AWS_S3_BUCKET}" --template-file "template.yaml" --output-template-file "output/plan"```

Deploy:
```aws cloudformation deploy --template-file "output/plan" --stack-name "cloudwatch-logging" --capabilities CAPABILITY_IAM --parameter-overrides "MyIp=${AWS_MY_IP}" "PemKey=${AWS_EC2_KEY}"```

---

## Generating Traffic
After you've created the instance you can generate some traffic by running the ```generate-traffic.sh``` bash script included in this repository. This will randomly choose between GET, PUT, POST, and DELETE methods while constructing a Curl request to the host name you provide. 

It will also determine whether to make the request a 404 or not by requestig a path that doesn't exist. The point of this is to generate traffic for graphing examples.

Example:

```./generate-traffic.sh -h "ec2-ip.compute-1.amazonaws.com"```

Script assumes port 80.

---

## Dashboards
As part of this template, a CloudWatch dashboard is created to visualize metric analysis of Apache logs. Visit the following URL to see the dashboard and widgets:

https://console.aws.amazon.com/cloudwatch/home?dashboards:name=Apache#dashboards:name=Apache