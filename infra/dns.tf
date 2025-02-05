locals {
  cloudflare_zone_id = "8fbf559fa97a8369c33564ddc4bdddf4"
}

resource "porkbun_nameservers" "jeselnik_xyz_nameservers" {
  domain = local.domain
  nameservers = [
    "emily.ns.cloudflare.com",
    "mitch.ns.cloudflare.com"
  ]
}

# web
resource "cloudflare_dns_record" "apex" {
  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = "jeselnik.xyz"
  content = "d1j60fm9ce00ec.cloudfront.net"
  ttl = 1
  proxied = false
}

resource "cloudflare_dns_record" "www" {
  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = "www"
  content = "d1j60fm9ce00ec.cloudfront.net"
  ttl = 1
  proxied = false
}

resource "cloudflare_dns_record" "eddie" {
  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = "eddie"
  content = "eddie-jeselnik-xyz.pages.dev"
  ttl = 1
  proxied = true
}

# mail



# verifications
resource "cloudflare_dns_record" "aws_acm" {
  zone_id = local.cloudflare_zone_id
  type    = "CNAME"
  name    = "_37df262c98dfb860e5335302990dc63e"
  content = "_08f9984ac88f193cc5c37febd9bbfaa2.mhbtsbpdnt.acm-validations.aws"
  ttl = 1
  proxied = false
}

