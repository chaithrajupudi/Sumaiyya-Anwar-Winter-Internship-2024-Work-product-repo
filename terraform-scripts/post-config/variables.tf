variable "projectInfo"{
    type = object({
        project = string
        region = string
    })
    
    default = {
        project = ""
        region = "asia-south1"
    }
}

variable "serviceAccountInfo" {
    type = object({
        id =  string        
    })

    default = {
        id =  "-sa"
    }
}

variable "sslCertInfo" {
    type = object({
        name = string        
    })

    default = {
        name = "-ssl-cert"        
     }
}

variable "networkInfo" {
    type = object({
        name =  string
        subnet = string
    })

    default = {
        name =  "-vpc"
        subnet = "-gke-subnet"
    }
}

variable lbipInfo {
    type = object({
        name = string
    })

    default = {
        name = "-glb-lb-ip"
    }
}

variable "negInfo" {
    type = object({
        name = string
    })

    default = {
        name = ""
     }
}

variable "negZoneInfo" {
    type = list(string)

    default = ["asia-south1-a", "asia-south1-b", "asia-south1-c"]
}

variable "hcInfo" {
    type = object({
        name = string
        path = string
        port = number
        port_spec = string
        check_interval = number
        timeout = number  
        threshold = number
    })

    default = {
        name = ""
        path = ""
        port = 0
        port_spec = ""
        check_interval = 0
        timeout = 0
        threshold = 0
     }
}

variable "bkendInfo" {
    type = object({
        name = string
        enable_cdn = bool
        balancing_mode = string
        max_rate = number
    })

    default = {
        name = ""
        enable_cdn = false
        balancing_mode = ""
        max_rate = 0
     }
}

variable "urlMapInfo" {
    type = object({
        name = string
        host_rules = list(object({
            hosts = list(string)
            path_matcher = string
        }))
        path_matchers = list(object({
            name = string
            path_rules = list(object({
                paths = list(string)                
            }))
        }))
    })

    default = {
        name = "url-map"
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
}

variable "proxyInfo" {
    type = object({
        name = string
    })

    default = {
        name = "https-proxy"
     }
}

variable "fwdRuleInfo" {
    type = object({
        name = string
    })

    default = {
        name = "fwd-rule"
     }
}
