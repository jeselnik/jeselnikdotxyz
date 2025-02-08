locals {
  sub_domains = toset(["@", "www", "eddie"])
}

data "cloudflare_zone" "jeselnik" {
  zone_id = local.cloudflare_zone_id
}

resource "porkbun_nameservers" "jeselnik_xyz_nameservers" {
  domain      = local.domain
  nameservers = data.cloudflare_zone.jeselnik.name_servers
}

# web
resource "cloudflare_dns_record" "sub_domains" {
  for_each = local.sub_domains
  zone_id  = local.cloudflare_zone_id
  type     = "CNAME"
  name     = each.value
  content  = "eddie-jeselnik-xyz.pages.dev"
  ttl      = 1
  proxied  = false
}

# mail
resource "cloudflare_dns_record" "mx_one" {
  zone_id  = local.cloudflare_zone_id
  type     = "MX"
  name     = "@"
  content  = "mxext1.mailbox.org"
  priority = 10
  ttl      = 1
  proxied  = false
}

resource "cloudflare_dns_record" "mx_two" {
  zone_id  = local.cloudflare_zone_id
  type     = "MX"
  name     = "@"
  content  = "mxext2.mailbox.org"
  priority = 10
  ttl      = 1
  proxied  = false
}

resource "cloudflare_dns_record" "mx_three" {
  zone_id  = local.cloudflare_zone_id
  type     = "MX"
  name     = "@"
  content  = "mxext3.mailbox.org"
  priority = 20
  ttl      = 1
  proxied  = false
}

resource "cloudflare_dns_record" "mailbox_verification" {
  zone_id = local.cloudflare_zone_id
  type    = "TXT"
  name    = "14f1418f9e2e43c3a85b1e5d51e8375b489a65e0"
  content = "\"badfc81752defbd61115d23081e02b0c7d76f7cc\""
  comment = "mailbox.org verification"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "dmarc" {
  zone_id = local.cloudflare_zone_id
  type    = "TXT"
  name    = "_dmarc"
  content = "\"v=DMARC1; p=quarantine; rua=mailto:8dc9dbdbc56c49859d95aa6ab5e3c4b5@dmarc-reports.cloudflare.net\""
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "spf" {
  zone_id = local.cloudflare_zone_id
  type    = "TXT"
  name    = "@"
  content = "\"v=spf1 include:mailbox.org ~all\""
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "dkim_one" {
  zone_id = local.cloudflare_zone_id
  type    = "TXT"
  name    = "mbo0001._domainkey"
  content = "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2K4PavXoNY8eGK2u61LIQlOHS8f5sWsCK5b+HMOfo0M+aNHwfqlVdzi/IwmYnuDKuXYuCllrgnxZ4fG4yVaux58v9grVsFHdzdjPlAQfp5rkiETYpCMZwgsmdseJ4CoZaosPHLjPumFE/Ua2WAQQljnunsM9TONM9L6KxrO9t5IISD1XtJb0bq1lVI/e72k3m\" \"nPd/q77qzhTDmwN4TSNJZN8sxzUJx9HNSMRRoEIHSDLTIJUK+Up8IeCx0B7CiOzG5w/cHyZ3AM5V8lkqBaTDK46AwTkTVGJf59QxUZArG3FEH5vy9HzDmy0tGG+053/x4RqkhqMg5/ClDm+lpZqWwIDAQAB\""
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "dkim_two" {
  zone_id = local.cloudflare_zone_id
  type    = "TXT"
  name    = "mbo0002._domainkey"
  content = "\"v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqxEKIg2c48ecfmy/+rj35sBOhdfIYGNDCMeHy0b36DX6MNtS7zA/VDR2q5ubtHzraL5uUGas8kb/33wtrWFYxierLRXy12qj8ItdYCRugu9tXTByEED05WdBtRzJmrb8YBMfeK0E0K3wwoWfhIk/wzKbjMkbqYBOTYLlIcVGQWzOfN7/n3n+VChfu6sGFK3k2\" \"qrJNnw22iFy4C8Ks7j77+tCpm0PoUwA2hOdLrRw3ldx2E9PH0GVwIMJRgekY6cS7DrbHrj/AeGlwfwwCSi9T23mYvc79nVrh2+82ZqmkpZSTD2qq+ukOkyjdRuUPck6e2b+x141Nzd81dIZVfOEiwIDAQAB\""
  ttl     = 1
  proxied = false
}

# verifications
resource "cloudflare_dns_record" "aws_acm" {
  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = "_37df262c98dfb860e5335302990dc63e"
  content = "_08f9984ac88f193cc5c37febd9bbfaa2.mhbtsbpdnt.acm-validations.aws"
  ttl     = 1
  proxied = false
}

