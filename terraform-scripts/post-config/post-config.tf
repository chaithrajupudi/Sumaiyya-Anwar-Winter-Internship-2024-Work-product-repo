provider "google" {
    project = var.projectInfo.project
    region = var.projectInfo.region   
}

data "google_service_account" "sa" {
    account_id = var.serviceAccountInfo.id
}

data "google_compute_global_address" "reserved_public_ip" {
    name = var.lbipInfo.name
}

data "google_compute_ssl_certificate" "ssl_cert" {
  name = var.sslCertInfo.name
}

data "google_compute_network_endpoint_group" "negs" {
    count = 3
    name = var.negInfo.name
    project = var.projectInfo.project
    zone = var.negZoneInfo[count.index]    
}

resource "google_compute_health_check" "lb_hc" {
  name = var.hcInfo.name  
  check_interval_sec = var.hcInfo.check_interval
  timeout_sec = var.hcInfo.timeout
  healthy_threshold = var.hcInfo.threshold
  unhealthy_threshold = var.hcInfo.threshold
  http_health_check {
    request_path = var.hcInfo.path
    port = var.hcInfo.port
    port_specification = "USE_FIXED_PORT"
  }
}

resource "google_compute_backend_service" "lb_bkend" {
    name = var.bkendInfo.name
    project = var.projectInfo.project
    enable_cdn = var.bkendInfo.enable_cdn
    load_balancing_scheme = "EXTERNAL_MANAGED"    
    protocol = "HTTP"
    backend {            
      balancing_mode = var.bkendInfo.balancing_mode
      max_rate = var.bkendInfo.max_rate
      group = data.google_compute_network_endpoint_group.negs[0].id
    }
    backend {      
      balancing_mode = var.bkendInfo.balancing_mode
      max_rate = var.bkendInfo.max_rate
      group = data.google_compute_network_endpoint_group.negs[1].id
    }
    backend {      
      balancing_mode = var.bkendInfo.balancing_mode
      max_rate = var.bkendInfo.max_rate
      group = data.google_compute_network_endpoint_group.negs[2].id
    }
    health_checks = [google_compute_health_check.lb_hc.id]
}

resource "google_compute_url_map" "lb_umap" {
  name = var.urlMapInfo.name
  project = var.projectInfo.project
  default_service = google_compute_backend_service.lb_bkend.id
  host_rule {
    hosts = var.urlMapInfo.host_rules[0].hosts
    path_matcher = var.urlMapInfo.host_rules[0].path_matcher
  }
  path_matcher {
    name = var.urlMapInfo.path_matchers[0].name
    default_service = google_compute_backend_service.lb_bkend.id
    path_rule {
      paths = var.urlMapInfo.path_matchers[0].path_rules[0].paths
      service = google_compute_backend_service.lb_bkend.id
    }
  }
  depends_on = [
      google_compute_backend_service.lb_bkend
  ]
}

resource "google_compute_target_https_proxy" "lb_https_proxy" {
  name = var.proxyInfo.name
  project = var.projectInfo.project
  url_map = google_compute_url_map.lb_umap.id
  ssl_certificates = [data.google_compute_ssl_certificate.ssl_cert.id]
  depends_on = [
      google_compute_url_map.lb_umap
  ]
}

resource "google_compute_global_forwarding_rule" "lb_frule" {
  name = var.fwdRuleInfo.name
  project = var.projectInfo.project
  target = google_compute_target_https_proxy.lb_https_proxy.id
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_range = "443"
  ip_address = data.google_compute_global_address.reserved_public_ip.id
}