locals {
  cloudflare_zone_id = "8fbf559fa97a8369c33564ddc4bdddf4"
}

data "cloudflare_zone" "jeselnik" {
  zone_id = local.cloudflare_zone_id
}

resource "porkbun_nameservers" "jeselnik_xyz_nameservers" {
  domain      = local.domain
  nameservers = data.cloudflare_zone.jeselnik.name_servers
}

# web
resource "cloudflare_dns_record" "apex" {
  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = "jeselnik.xyz"
  content = "d1j60fm9ce00ec.cloudfront.net"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "www" {
  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = "www"
  content = "d1j60fm9ce00ec.cloudfront.net"
  ttl     = 1
  proxied = false
}

resource "cloudflare_dns_record" "eddie" {
  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = "eddie"
  content = "eddie-jeselnik-xyz.pages.dev"
  ttl     = 1
  proxied = true
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

# verifications
resource "cloudflare_dns_record" "aws_acm" {
  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = "_37df262c98dfb860e5335302990dc63e"
  content = "_08f9984ac88f193cc5c37febd9bbfaa2.mhbtsbpdnt.acm-validations.aws"
  ttl     = 1
  proxied = false
}

