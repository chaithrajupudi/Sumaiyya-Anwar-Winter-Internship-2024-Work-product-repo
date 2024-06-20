projectInfo = {
    project = ""
        region = "asia-south1"
    
}

serviceAccountInfo = {
    id =  "-dev-sa"
}

networkInfo = {
    name =  "-dev-vpc"
    subnet = "-dev-gke-subnet"
}

sslCertInfo = {
    name = "-dev-ssl-cert"    
}

lbipInfo = {
    name = "-dev-glb-lb-ip"
}

negInfo = {
    name = "-dev-nginx-80-neg"
}

negZoneInfo = ["asia-south1-a", "asia-south1-b", "asia-south1-c"]

bkendInfo = {
    name = "-dev-bkend-service"
    enable_cdn = false
}

hcInfo = {
    name = "-dev-hcinfo"
    request_path = "/healthz"
    port = 10254
    checkInterval = 5
    timeout = 1
}

urlMapInfo = {
     name = "-dev-url-map"
    host_rules = [
    {
        hosts = ["*"]
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
