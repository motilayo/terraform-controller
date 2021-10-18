module "redis" {
  source               = "terraform-alicloud-modules/redis/alicloud"
  engine_version       = "5.0"
  instance_name        = var.instance_name
  instance_class       = "redis.master.mid.default"
  period               = 1
  instance_charge_type = "PostPaid"

  #################
  # Redis Accounts
  #################

  accounts = [
    {
      account_name      = var.account_name
      account_password  = var.password
      account_privilege = "RoleReadWrite"
      account_type      = "Normal"
    },
  ]

  #################
  # Redis backup_policy
  #################

  backup_policy_backup_time   = "02:00Z-03:00Z"
  backup_policy_backup_period = ["Monday", "Wednesday", "Friday"]

  #############
  # cms_alarm
  #############

  alarm_rule_name            = "CmsAlarmForRedis"
  alarm_rule_statistics      = "Average"
  alarm_rule_period          = 300
  alarm_rule_operator        = "<="
  alarm_rule_threshold       = 35
  alarm_rule_triggered_count = 2
  alarm_rule_contact_groups  = [var.alarm_contact_group]

}
output "REDIS_NAME" {
  value = module.redis.this_redis_instance_name
}

output "REDIS_CONNECT_ADDRESS" {
  value = format("%s.%s", module.redis.this_redis_instance_id, "redis.rds.aliyuncs.com")
}

output "REDIS_USER" {
  value = module.redis.this_redis_instance_account_name
}

output "REDIS_ID" {
  value = module.redis.this_redis_instance_id
}

variable "instance_name" {
  description = "Redis instance name"
  type        = string
  default     = "oam-redis"
}

variable "account_name" {
  description = "Redis instance user account name"
  type        = string
  default     = "oam"
}

variable "password" {
  description = "RDS instance account password"
  type        = string
  default     = "Xyfff83jfewGGfaked"
}

variable "alarm_contact_group" {
  description = "Alicloud CMS contact groups of the alarm rule.This must have been created at alicloud console"
  default = "redis-test"
}
