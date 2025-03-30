variable "project_name" {
  description = "Name of the project for resource naming"
  type        = string
}

variable "retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}