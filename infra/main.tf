terraform {
  required_version = ">= 1.0"

  required_providers {
    huaweicloud = {
      source  = "huaweicloud/huaweicloud"
      version = "~> 1.98"
    }
  }
}

provider "huaweicloud" {
  region     = var.hw_region
  access_key = var.hw_access_key
  secret_key = var.hw_secret_key
}

# ============================================
# VPC & Networking
# ============================================

resource "huaweicloud_vpc" "main" {
  name = "trust-safety-vpc"
  cidr = var.vpc_cidr
}

resource "huaweicloud_vpc_subnet" "main" {
  name       = "trust-safety-subnet"
  vpc_id     = huaweicloud_vpc.main.id
  cidr       = var.subnet_cidr
  gateway_ip = cidrhost(var.subnet_cidr, 1)
}

resource "huaweicloud_networking_secgroup" "main" {
  name = "trust-safety-sg"
}

resource "huaweicloud_networking_secgroup_rule" "ingress_tcp" {
  security_group_id = huaweicloud_networking_secgroup.main.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "huaweicloud_networking_secgroup_rule" "ingress_udp" {
  security_group_id = huaweicloud_networking_secgroup.main.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "udp"
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "huaweicloud_networking_secgroup_rule" "ingress_icmp" {
  security_group_id = huaweicloud_networking_secgroup.main.id
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "icmp"
  remote_ip_prefix  = "0.0.0.0/0"
}

resource "huaweicloud_networking_secgroup_rule" "egress" {
  security_group_id = huaweicloud_networking_secgroup.main.id
  direction         = "egress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  remote_ip_prefix  = "0.0.0.0/0"
}

# ============================================
# OBS Bucket (Evidence Storage)
# ============================================

resource "huaweicloud_obs_bucket" "evidence" {
  bucket     = "trust-safety-evidence-${var.project_id}"
  acl        = "private"
  versioning = true

  lifecycle_rule {
    name    = "archive-old-evidence"
    prefix  = "archive/"
    enabled = true

    expiration {
      days = 90
    }
  }
}

# ============================================
# FunctionGraph Functions
# ============================================

resource "huaweicloud_fgs_function" "event_processor" {
  name        = "trust-safety-event-processor"
  runtime     = "Python3.9"
  handler     = "index.handler"
  memory_size = 128
  timeout     = 30
  app         = "default"
  code_type   = "inline"

  func_code = base64encode(<<-EOF
# -*- coding: utf-8 -*-
import json

def handler(event, context):
    print("Received event:", event)
    return {
        "statusCode": 200,
        "body": json.dumps({"result": "processed"})
    }
EOF
  )
}

resource "huaweicloud_fgs_function" "policy_engine" {
  name        = "trust-safety-policy-engine"
  runtime     = "Python3.9"
  handler     = "index.handler"
  memory_size = 256
  timeout     = 60
  app         = "default"
  code_type   = "inline"

  func_code = base64encode(<<-EOF
# -*- coding: utf-8 -*-
import json

def handler(event, context):
    print("Received event:", event)
    return {
        "statusCode": 200,
        "body": json.dumps({"action": "auto_execute", "confidence": 0.95})
    }
EOF
  )
}
