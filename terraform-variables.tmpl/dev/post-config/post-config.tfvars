projectInfo = {
    project = ""
        region = "asia-south1"
    
}

serviceAccountInfo = {
    id =  "-sa"
}

networkInfo = {
    name =  "-vpc"
    subnet = "-gke-subnet"
}

sslCertInfo = {
    name = "-ssl-cert"    
}

lbipInfo = {
    name = "-glb-lb-ip"
}

negInfo = {
    name = "-nginx-80-neg"
}

negZoneInfo = ["asia-south1-a", "asia-south1-b", "asia-south1-c"]

bkendInfo = {
    name = "-bkend-service"
    enable_cdn = false
}

hcInfo = {
    name = "-hcinfo"
    request_path = "/healthz"
    port = 10254
    checkInterval = 5
    timeout = 1
}

urlMapInfo = {
     name = "-url-map"
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
    name = "-https-proxy"
}

fwdRuleInfo = {
    name = "-fwd-rule"
}
