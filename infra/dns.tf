resource "aws_route53_zone" "jeselnikdotxyz" {
  name          = "jeselnik.xyz"
  force_destroy = true
}

locals {
  default_ttl = 300
}

/* begin email */
resource "aws_route53_record" "mx" {
  zone_id = aws_route53_zone.jeselnikdotxyz.zone_id
  type    = "MX"
  name    = "jeselnik.xyz"
  records = [
    "10 mxext1.mailbox.org",
    "10 mxext2.mailbox.org",
    "20 mxext3.mailbox.org"
  ]
  ttl = local.default_ttl
}

resource "aws_route53_record" "mailbox_org_verification" {
  zone_id = aws_route53_zone.jeselnikdotxyz.zone_id
  type    = "TXT"
  name    = "14f1418f9e2e43c3a85b1e5d51e8375b489a65e0"
  records = ["badfc81752defbd61115d23081e02b0c7d76f7cc"]
  ttl     = local.default_ttl
}

resource "aws_route53_record" "spf" {
  zone_id = aws_route53_zone.jeselnikdotxyz.zone_id
  type    = "TXT"
  name    = "jeselnik.xyz"
  records = ["v=spf1 include:mailbox.org ~all"]
  ttl     = local.default_ttl
}

/* Records limited to 255 characters, 
https://repost.aws/knowledge-center/route53-resolve-dkim-text-record-error
*/
resource "aws_route53_record" "dkim1" {
  zone_id = aws_route53_zone.jeselnikdotxyz.zone_id
  type    = "TXT"
  name    = "mbo0001._domainkey"
  records = [
    "v=DKIM1; k=rsa; ",
    "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2K4PavXoNY8eGK2u61LIQlOHS8f5sWsCK5b+HMOfo0M+aNH",
    "wfqlVdzi/IwmYnuDKuXYuCllrgnxZ4fG4yVaux58v9grVsFHdzdjPlAQfp5rkiETYpCMZwgsmdseJ4CoZaosPHLjPumF",
    "E/Ua2WAQQljnunsM9TONM9L6KxrO9t5IISD1XtJb0bq1lVI/e72k3mnPd/q77qzhTDmwN4TSNJZN8sxzUJx9HNSMRRoEIHSD",
    "LTIJUK+Up8IeCx0B7CiOzG5w/cHyZ3AM5V8lkqBaTDK46AwTkTVGJf59QxUZArG3FEH5vy9HzDmy0tGG+053/x4RqkhqMg",
    "5/ClDm+lpZqWwIDAQAB"
  ]
  ttl = local.default_ttl
}

resource "aws_route53_record" "dkim2" {
  zone_id = aws_route53_zone.jeselnikdotxyz.zone_id
  type    = "TXT"
  name    = "mbo0002._domainkey"
  records = [
    "v=DKIM1; k=rsa; ",
    "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqxEKIg2c48ecfmy/+rj35sBOhdfIYGNDCMeHy0b36DX6MNtS7",
    "zA/VDR2q5ubtHzraL5uUGas8kb/33wtrWFYxierLRXy12qj8ItdYCRugu9tXTByEED05WdBtRzJmrb8YBMfeK0E0K3wwoWfh",
    "Ik/wzKbjMkbqYBOTYLlIcVGQWzOfN7/n3n+VChfu6sGFK3k2qrJNnw22iFy4C8Ks7j77+tCpm0PoUwA2hOdLrRw3ldx2E9P",
    "H0GVwIMJRgekY6cS7DrbHrj/AeGlwfwwCSi9T23mYvc79nVrh2+82ZqmkpZSTD2qq+ukOkyjdRuUPck6e2b+x141Nzd81dIZ",
    "VfOEiwIDAQAB"
  ]
  ttl = local.default_ttl
}

resource "aws_route53_record" "dmarc" {
  zone_id = aws_route53_zone.jeselnikdotxyz.zone_id
  type    = "TXT"
  name    = "_dmarc"
  records = ["v=DMARC1; p=quarantine"]
  ttl     = local.default_ttl
}
/* end email */
