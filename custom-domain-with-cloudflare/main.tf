terraform {
  required_providers {
    pingone = {
      source = "pingidentity/pingone"
      version = "0.4.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "3.23.0"
    }
  }
}

provider "pingone" {
  # Configuration options
}

provider "cloudflare" {
  # Configuration options
}

data "pingone_environment" "my_environment" {
  name = var.environment_name
}

resource "pingone_custom_domain" "my_custom_domain" {
  environment_id = data.pingone_environment.my_environment.id

  domain_name = "${var.domain_cname}.${var.domain_zone}"
}

data "cloudflare_zone" "domain" {
  name = var.domain_zone
}

resource "cloudflare_record" "foobar" {
  zone_id = data.cloudflare_zone.domain.id

  name    = var.domain_cname
  value   = pingone_custom_domain.my_custom_domain.canonical_name
  type    = "CNAME"
  ttl     = 3600
}

resource "pingone_custom_domain_verify" "my_custom_domain" {
  environment_id = data.pingone_environment.my_environment.id

  custom_domain_id = pingone_custom_domain.my_custom_domain.id

  depends_on = [
    cloudflare_record.foobar
  ]
}

resource "pingone_custom_domain_ssl" "my_custom_domain" {
  environment_id = data.pingone_environment.my_environment.id

  custom_domain_id = pingone_custom_domain.my_custom_domain.id

  certificate_pem_file               = var.certificate_pem_file
  intermediate_certificates_pem_file = var.intermediate_certificates_pem_file
  private_key_pem_file               = var.private_key_pem_file

  depends_on = [
    pingone_custom_domain_verify.my_custom_domain
  ]
}
