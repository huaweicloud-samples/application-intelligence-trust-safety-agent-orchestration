# 部署指南

## 前置条件

- 华为云账号
- 有效的 Access Key 和 Secret Key
- Terraform CLI (>= 1.0)
- Node.js 20+ (用于前端构建)

## 步骤 1: 配置凭据

在 `infra` 目录下：

```bash
cd infra
cp terraform.tfvars.example terraform.tfvars
```

编辑 `terraform.tfvars`，填入您的华为云凭据：

```hcl
hw_access_key = "your-access-key"
hw_secret_key = "your-secret-key"
hw_region     = "cn-north-4"
project_id    = "your-project-id"
```

## 步骤 2: 初始化 Terraform

```bash
terraform init
```

## 步骤 3: 预览变更

```bash
terraform plan
```

## 步骤 4: 部署资源

```bash
terraform apply
```

输入 `yes` 确认部署。

## 步骤 5: 部署前端

```bash
cd frontend
npm install
npm run build
```

## 验证

部署完成后：

1. 访问 APIG 端点验证 API 可用
2. 检查 FunctionGraph 函数状态
3. 验证 GaussDB 连接
4. 检查 OBS 桶

## 清理资源

```bash
terraform destroy
```

输入 `yes` 确认销毁。

## 故障排查

### FunctionGraph 调用失败

- 检查函数日志 (FunctionGraph → 日志)
- 验证 IAM 委托配置

### APIG 调用超时

- 检查函数超时设置
- 验证安全组规则

### GaussDB 连接失败

- 检查 VPC 配置
- 验证安全组入站规则
