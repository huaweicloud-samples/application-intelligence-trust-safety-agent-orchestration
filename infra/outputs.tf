output "vpc_id" {
  description = "VPC ID"
  value       = huaweicloud_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = huaweicloud_vpc.main.cidr
}

output "subnet_id" {
  description = "Subnet ID"
  value       = huaweicloud_vpc_subnet.main.id
}

output "security_group_id" {
  description = "Security Group ID"
  value       = huaweicloud_networking_secgroup.main.id
}

output "obs_bucket" {
  description = "OBS Bucket name for evidence storage"
  value       = huaweicloud_obs_bucket.evidence.bucket
}

output "event_processor_urn" {
  description = "Event processor FunctionGraph URN"
  value       = huaweicloud_fgs_function.event_processor.urn
}

output "policy_engine_urn" {
  description = "Policy engine FunctionGraph URN"
  value       = huaweicloud_fgs_function.policy_engine.urn
}
