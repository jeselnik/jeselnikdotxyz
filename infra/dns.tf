resource "porkbun_nameservers" "jeselnik_xyz_nameservers" {
  domain = "jeselnik.xyz"
  nameservers = [
    "emily.ns.cloudflare.com",
    "mitch.ns.cloudflare.com"
  ]
}
