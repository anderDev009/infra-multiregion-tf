provider "aws" {
  region = "us-east-1"
  alias  = "primary"
  endpoints {
    dynamodb       = "http://192.168.1.101:4566"
    secretsmanager = "http://192.168.1.101:4566"
    s3             = "http://192.168.1.101:4566"
    sns            = "http://192.168.1.101:4566"
    sqs            = "http://192.168.1.101:4566"
    ssm            = "http://192.168.1.101:4566"
    iam            = "http://192.168.1.101:4566"
    sts            = "http://192.168.1.101:4566"
    elbv2          = "http://192.168.1.101:4566"
    ec2            = "http://192.168.1.101:4566"
    route53        = "http://192.168.1.101:4566"
    autoscaling    = "http://192.168.1.101:4566"
  }
}
provider "aws" {
  region = "us-west-2"
  alias  = "secondary"
  endpoints {
    dynamodb       = "http://192.168.1.101:4566"
    secretsmanager = "http://192.168.1.101:4566"
    s3             = "http://192.168.1.101:4566"
    sns            = "http://192.168.1.101:4566"
    sqs            = "http://192.168.1.101:4566"
    ssm            = "http://192.168.1.101:4566"
    iam            = "http://192.168.1.101:4566"
    sts            = "http://192.168.1.101:4566"
    elbv2          = "http://192.168.1.101:4566"
    ec2            = "http://192.168.1.101:4566"
    route53        = "http://192.168.1.101:4566"
    autoscaling    = "http://192.168.1.101:4566"
  }
}