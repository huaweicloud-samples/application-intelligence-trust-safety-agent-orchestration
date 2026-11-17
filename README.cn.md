# Trust & Safety Orchestration Agent

[![License: MIT No Attribution](https://img.shields.io/badge/License-MIT%20No%20Attribution-blue.svg)](LICENSE)
[![华为云](https://img.shields.io/badge/华为云-FunctionGraph-green.svg)](https://www.huaweicloud.com/product/functiongraph.html)

> [English](README.md)

## 简介

本项目展示了如何在华为云上构建一个**自主式 Trust & Safety 系统**，使用多智能体编排技术来检测、调查和解决策略违规。

该系统结合了事件驱动处理、并行证据收集、置信度评分决策和自动化执行，能够处理内容审核和安全策略执行，并通过人工介入升级处理敏感案例。系统遵循事件驱动管道：**检测 (Detection) → 调查 (Investigation) → 决策 (Decision) → 执行 (Enforcement)**。

### 核心价值

1. **事件驱动架构**：DIS 流接入 + FunctionGraph 实时处理，实现高吞吐量事件处理
2. **工作流编排**：FunctionGraph DAG 实现复杂的调查工作流，支持并行证据收集
3. **置信度决策**：基于规则的策略引擎，高置信度自动执行，低置信度人工审查
4. **完整审计**：所有操作记录审计日志，支持合规追溯
5. **实时更新**：WebSocket 推送，仪表盘实时展示事件状态

### 适用场景

- 内容审核平台
- 用户行为监控系统
- 安全策略执行系统
- 合规审计系统

## 目录

- [架构](#架构)
- [方案亮点](#方案亮点)
- [涉及云服务](#涉及云服务)
- [前置条件](#前置条件)
- [快速开始](#快速开始)
- [使用方法](#使用方法)
- [清理资源](#清理资源)
- [详细说明](#详细说明)
- [许可证](#许可证)
- [联系方式](#联系方式)

## 架构

```
┌─────────────────────────────────────────────────────────────────┐
│                        数据流                                     │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────────┐    ┌──────────────────┐     │
│  │  事件源   │───▶│  DIS Stream  │───▶│  FunctionGraph  │     │
│  └──────────┘    └──────────────┘    └────────┬─────────┘     │
│                                                  │               │
│                                                  ▼               │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │              FunctionGraph DAG (调查工作流)               │    │
│  └──────────────────────────┬───────────────────────────────┘    │
│                             │                                   │
│          ┌─────────────────┴─────────────────┐                  │
│          ▼                                   ▼                  │
│  ┌─────────────────┐           ┌─────────────────┐           │
│  │  自动执行引擎   │           │  人工审查队列   │           │
│  └────────┬────────┘           └────────┬────────┘           │
│           │                              │                     │
│           ▼                              ▼                     │
│  ┌──────────────────────────────────────────────┐            │
│  │              GaussDB-Mongo + OBS + DCS        │            │
│  └──────────────────────────────────────────────┘            │
│                                                                 │
│           ┌──────────────────────────────────┐                │
│           │     APIG (REST + WebSocket)      │                │
│           └──────────────┬───────────────────┘                │
│                          ▼                                    │
│           ┌──────────────────────────┐                        │
│           │    React 前端仪表盘       │                        │
│           └──────────────────────────┘                        │
└─────────────────────────────────────────────────────────────────┘
```

## 方案亮点

- **Serverless 架构**：基于 FunctionGraph，无需管理服务器，按需付费
- **事件驱动**：DIS 流接入，实时处理海量事件
- **并行处理**：DAG 编排支持并行证据收集，提高处理效率
- **人工介入**：敏感案例自动升级人工审查，确保安全

## 涉及云服务

| 服务 | 用途 |
|------|------|
| FunctionGraph | 事件处理、业务逻辑、工作流编排 |
| GaussDB-Mongo | 案例、证据、审计日志存储 |
| OBS | 证据文件存储、审计归档 |
| DCS | 限流、缓存、会话管理 |
| APIG | REST API、WebSocket 实时更新 |
| DIS | 行为事件流接入 |
| CES | 监控告警 |

**清理资源提示**：部署完成后请及时清理不再使用的资源，避免资源残留。

## 前置条件

- 华为云账号
- 有效的 Access Key 和 Secret Key
- Terraform CLI (>= 1.0)
- Node.js 20+ (前端构建)

### 区域要求

推荐使用 `cn-north-4` (华北北京四) 区域。

### 权限要求

需要以下服务权限：
- FunctionGraph FullAccess
- GaussDB FullAccess
- OBS OperateButton
- DCS FullAccess
- APIG FullAccess
- DIS FullAccess
- CES FullAccess
- VPC FullAccess

## 快速开始

### 1. 克隆仓库

```bash
git clone <repository-url>
cd application-intelligence-trust-safety-agent-orchestration
```

### 2. 配置凭据

```bash
cd infra
cp terraform.tfvars.example terraform.tfvars
```

编辑 `terraform.tfvars`，填入您的华为云凭据：

```hcl
hw_access_key = "<YOUR_ACCESS_KEY>"
hw_secret_key = "<YOUR_SECRET_KEY>"
hw_region     = "cn-north-4"
project_id    = "<YOUR_PROJECT_ID>"
```

### 3. 部署基础设施

```bash
terraform init
terraform plan
terraform apply
```

### 4. 部署前端

```bash
cd frontend
npm install
npm run build
```

## 使用方法

### 验证部署

部署完成后，验证各组件状态：

1. **验证 FunctionGraph 函数**
```bash
# 在华为云控制台 FunctionGraph 服务中查看函数状态
# 确保以下函数状态为 "已发布"：
# - trust-safety-event-processor
# - trust-safety-policy-engine
```

2. **验证 DIS 流**
```bash
# 在控制台 DIS 服务中查看流状态
# 确保流 "trust-safety-events" 状态为 "运行中"
```

3. **验证 OBS 桶**
```bash
# 在控制台 OBS 服务中查看桶
# 确保桶 "trust-safety-evidence-*" 存在
```

4. **测试 API 调用**
```bash
# 如果启用了 APIG，测试事件提交
curl -X POST https://<apig-endpoint>/events \
  -H "Content-Type: application/json" \
  -d '{"event_type": "test", "data": {"user_id": "test-user"}}'
```

### 仪表盘访问

前端部署后，访问 `http://localhost:3000` 或部署的 CloudFront 域名查看实时仪表盘。

## 清理资源

```bash
cd infra
terraform destroy
```

## 详细说明

### 事件流程

1. **检测阶段**：事件通过 DIS 流入，FunctionGraph 进行异常评分
2. **调查阶段**：触发 DAG 工作流，并行收集多维度证据
3. **决策阶段**：置信度计算，策略引擎决定执行路径
4. **执行阶段**：高置信度自动执行，低置信度升级人工审查

### 配置选项

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `enable_database` | 启用 GaussDB MongoDB | false |
| `enable_redis` | 启用 DCS Redis | false |
| `enable_apig` | 启用 APIG | false |

### 安全最佳实践

- 所有 FunctionGraph 函数使用最小权限 IAM 策略
- GaussDB 表加密存储
- OBS 桶强制加密
- API 端点需要认证
- 审计日志不可变

## 许可证

本实践采用 MIT No Attribution 许可证。

See [LICENSE](LICENSE) file for details.

## 联系方式

- **维护团队**：公有云持续运营部
- **邮箱**：cloud-support@huawei.com
