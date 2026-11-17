# Trust & Safety Orchestration Agent

[![License: MIT No Attribution](https://img.shields.io/badge/License-MIT%20No%20Attribution-blue.svg)](LICENSE)
[![Huawei Cloud](https://img.shields.io/badge/华为云-FunctionGraph-green.svg)](https://www.huaweicloud.com/product/functiongraph.html)

> [中文](README.cn.md)

## Overview

This project demonstrates how to build an **autonomous Trust & Safety system** on Huawei Cloud using multi-agent orchestration to detect, investigate, and resolve policy violations at scale.

The system combines event-driven processing, parallel evidence gathering, confidence-scored decision making, and automated enforcement to handle content moderation and safety enforcement with human-in-the-loop escalation for sensitive cases. The system follows an event-driven pipeline: **Detection → Investigation → Decision → Enforcement**.

### Core Values

1. **Event-Driven Architecture**: DIS stream ingestion + FunctionGraph real-time processing for high-throughput event handling
2. **Workflow Orchestration**: FunctionGraph DAG implements complex investigation workflows with parallel evidence collection
3. **Confidence-Based Decision**: Rule-based policy engine with auto-execution for high confidence and human review for low confidence
4. **Complete Audit Trail**: All operations logged for compliance tracking
5. **Real-Time Updates**: WebSocket push for real-time dashboard updates

### Use Cases

- Content moderation platforms
- User behavior monitoring systems
- Security policy enforcement systems
- Compliance audit systems

## Table of Contents

- [Architecture](#architecture)
- [Key Features](#key-features)
- [Cloud Services](#cloud-services)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Usage](#usage)
- [Cleanup](#cleanup)
- [Detailed Description](#detailed-description)
- [License](#license)
- [Contact](#contact)

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Data Flow                                 │
├─────────────────────────────────────────────────────────────────┤
│  ┌──────────┐    ┌──────────────┐    ┌──────────────────┐     │
│  │  Source  │───▶│  DIS Stream  │───▶│  FunctionGraph  │     │
│  └──────────┘    └──────────────┘    └────────┬─────────┘     │
│                                                  │               │
│                                                  ▼               │
│  ┌──────────────────────────────────────────────────────────┐    │
│  │              FunctionGraph DAG (Investigation)           │    │
│  └──────────────────────────┬───────────────────────────────┘    │
│                             │                                   │
│          ┌─────────────────┴─────────────────┐                  │
│          ▼                                   ▼                  │
│  ┌─────────────────┐           ┌─────────────────┐           │
│  │ Auto Enforcer   │           │ Human Review    │           │
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
│           │    React Dashboard       │                        │
│           └──────────────────────────┘                        │
└─────────────────────────────────────────────────────────────────┘
```

## Key Features

- **Serverless Architecture**: Built on FunctionGraph, no server management, pay-as-you-go
- **Event-Driven**: DIS stream ingestion for real-time processing of massive events
- **Parallel Processing**: DAG orchestration supports parallel evidence collection
- **Human-in-the-Loop**: Sensitive cases automatically escalate to human review

## Cloud Services

| Service | Purpose |
|---------|---------|
| FunctionGraph | Event processing, business logic, workflow orchestration |
| GaussDB-Mongo | Cases, evidence, audit log storage |
| OBS | Evidence file storage, audit archives |
| DCS | Rate limiting, caching, session management |
| APIG | REST API, WebSocket real-time updates |
| DIS | Behavioral event stream ingestion |
| CES | Monitoring and alerts |

**Note**: Please clean up unused resources after deployment to avoid resource lingering.

## Prerequisites

- Huawei Cloud account
- Valid Access Key and Secret Key
- Terraform CLI (>= 1.0)
- Node.js 20+ (for frontend build)

### Region Requirements

Recommended region: `cn-north-4` (Beijing Four)

### Required Permissions

The following service permissions are required:
- FunctionGraph FullAccess
- GaussDB FullAccess
- OBS OperateButton
- DCS FullAccess
- APIG FullAccess
- DIS FullAccess
- CES FullAccess
- VPC FullAccess

## Quick Start

### 1. Clone the Repository

```bash
git clone <repository-url>
cd application-intelligence-trust-safety-agent-orchestration
```

### 2. Configure Credentials

```bash
cd infra
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and fill in your Huawei Cloud credentials:

```hcl
hw_access_key = "<YOUR_ACCESS_KEY>"
hw_secret_key = "<YOUR_SECRET_KEY>"
hw_region     = "cn-north-4"
project_id    = "<YOUR_PROJECT_ID>"
```

### 3. Deploy Infrastructure

```bash
terraform init
terraform plan
terraform apply
```

### 4. Deploy Frontend

```bash
cd frontend
npm install
npm run build
```

## Usage

### Verify Deployment

After deployment, verify component status:

1. **Verify FunctionGraph Functions**
```bash
# Check function status in Huawei Cloud console FunctionGraph service
# Ensure the following functions are in "Published" state:
# - trust-safety-event-processor
# - trust-safety-policy-engine
```

2. **Verify DIS Stream**
```bash
# Check stream status in console DIS service
# Ensure stream "trust-safety-events" is "Running"
```

3. **Verify OBS Bucket**
```bash
# Check bucket in console OBS service
# Ensure bucket "trust-safety-evidence-*" exists
```

4. **Test API Call**
```bash
# If APIG is enabled, test event submission
curl -X POST https://<apig-endpoint>/events \
  -H "Content-Type: application/json" \
  -d '{"event_type": "test", "data": {"user_id": "test-user"}}'
```

### Dashboard Access

After frontend deployment, visit `http://localhost:3000` or the deployed CloudFront domain to view the real-time dashboard.

## Cleanup

```bash
cd infra
terraform destroy
```

## Detailed Description

### Event Flow

1. **Detection**: Events flow in via DIS, FunctionGraph performs anomaly scoring
2. **Investigation**: Triggers DAG workflow, parallel evidence collection
3. **Decision**: Confidence scoring, policy engine routes execution path
4. **Execution**: Auto-execute for high confidence, escalate to human review for low confidence

### Configuration Options

| Variable | Description | Default |
|----------|-------------|---------|
| `enable_database` | Enable GaussDB MongoDB | false |
| `enable_redis` | Enable DCS Redis | false |
| `enable_apig` | Enable APIG | false |

### Security Best Practices

- All FunctionGraph functions use least-privilege IAM policies
- GaussDB tables use encryption at rest
- OBS buckets enforce encryption
- API endpoints require authentication
- Audit logs are immutable

## License

This practice adopts the MIT No Attribution license.

See [LICENSE](LICENSE) file for details.

## Contact

- **Team**: Public Cloud Continuous Operations
- **Email**: cloud-support@huawei.com
