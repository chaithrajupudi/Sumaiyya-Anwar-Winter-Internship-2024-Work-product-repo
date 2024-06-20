projectInfo = {
    project = ""
        region = "asia-south1"
    
}

serviceAccountInfo = {
    id =  "x-dev-sa"
}

networkInfo = {
    name =  "-dev-vpc"
    subnet = "-dev-gke-subnet"
}

sslCertInfo = {
    name = "-ssl-cert"    
}

lbipInfo = {
    name = "-dev-glb-lb-ip"
}

negInfo = {
    name = "-dev-nginx-80-neg"
}

negZoneInfo = ["asia-south1-a", "asia-south1-b", "asia-south1-c"]

hcInfo = {
    name = "-dev-hcinfo"
    path = "/healthz/ready"
    port = 15021
    port_spec = "USE_FIXED_PORT"
    check_interval = 5
    timeout = 5
    threshold = 2
}

bkendInfo = {
    name = "-bkend-service"
    enable_cdn = false
    balancing_mode = "RATE"
    max_rate = 80
}

urlMapInfo = {
    name = "-fwd-rule"
    host_rules = [
    {
        hosts = [""]
        path_matcher = "default"
    }]
    path_matchers = [
    {
        name = "default"
        path_rules = [
        {
            paths = ["/*"]
        }]
    }]
}

proxyInfo = {
    name = "-dev-https-proxy"
}

fwdRuleInfo = {
    name = "-dev-fwd-rule"
}
