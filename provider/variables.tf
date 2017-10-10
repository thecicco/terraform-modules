variable "region" {
  default = "it-mil1"
}
variable "auth_url" {
  default = "https://api.${var.region}.entercloudsuite.com/v2.0"
}
variable tenant_name {}
variable user_name {}
variable password {}
