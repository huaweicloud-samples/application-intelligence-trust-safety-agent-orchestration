$env:TF_CLI_CONFIG_FILE = "C:/Users/xiang/WorkBuddy/aws-huaweisamples/huaweicloud/4批/application-intelligence-trust-safety-agent-orchestration/infra/dev.rc"
Set-Location "C:/Users/xiang/WorkBuddy/aws-huaweisamples/huaweicloud/4批/application-intelligence-trust-safety-agent-orchestration/infra"
terraform plan -var-file=terraform.tfvars
