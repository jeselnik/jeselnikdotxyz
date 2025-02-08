locals {
  cloudflare_account_id = "8940638f1a127e97ec240934e06b73e5"
}

/* https://github.com/cloudflare/terraform-provider-cloudflare/pull/5054
resource "cloudflare_list" "apex_redirect" {
  account_id = local.cloudflare_account_id
  kind       = "hostname"
  name       = "apex_redirect"
}

resource "cloudflare_list_item" "jeselnik_xyz_redirects" {
  list_id    = cloudflare_list.apex_redirect.id
  account_id = local.cloudflare_account_id
  body = [{
    redirect = {
      source_url            = "jeselnik.xyz"
      target_url            = "eddie.jeselnik.xyz"
      status_code           = 301
      include_subdomains    = false
      subpath_matching      = false
      preserve_query_string = false
      preserve_path_suffix  = false
    }
  }]
}
*/
