projectInfo = {
    project = ""
    region = "asia-south1"
}

serviceAccountInfo = {
    name = "-dev-sa@PROJECT_ID.iam.gserviceaccount.com"
}

networkInfo = {
    name = "-dev-vpc"
    auto_create_subnetworks = false
    mtu = 1460
    gke_subnet = {
        name = "-dev-gke-subnet"
        ip_cidr_range = "10.0.0.0/24"
        pods_ip_range = {
            range_name = "pods-range"
            ip_cidr_range = "10.2.0.0/16"
        }
        services_ip_range = {
            range_name = "servicess-range"
            ip_cidr_range = "10.3.0.0/16"
        }
    },
    psc_subnet = {
        name = "-dev-psc-subnet"
        ip_cidr_range = "10.0.1.0/24"
        purpose = "PRIVATE_SERVICE_CONNECT"
    },
    proxy_subnet = {
        name = "-dev-proxy-subnet"
        ip_cidr_range = "10.0.2.0/24"
        purpose = "REGIONAL_MANAGED_PROXY"
    },
    operations_subnet = {
        name = "-dev-operations-subnet",
        ip_cidr_range = "10.0.3.0/24"
    }
}

firewallPolicyInfo = {
    name = "-dev-nw-policy"
    description = ""
}

firewallPolicyAssocInfo = {
    name = "-dev-nw-policy-assoc"
}

firewallRuleInfo = [
    {
        name = "-dev-allow-ssh"
        action = "allow"
        description = ""
        direction = "INGRESS"
        disabled = false
        enable_logging = false
        firewall_policy = ""
        priority = 100
        match = {
            src_ip_ranges = ["0.0.0.0/0"]
            layer4_configs = {
                ip_protocol = "tcp"
                ports = ["22"]
            }
        }
    },
    {
        name = "-dev-allow-http(s)"
        action = "allow"
        description = ""
        direction = "INGRESS"
        disabled = false
        enable_logging = true
        firewall_policy = ""
        priority = 101
        match = {
            src_ip_ranges = ["0.0.0.0/0"]
            layer4_configs = {
                ip_protocol = "tcp"
                ports = ["80", "443", "8080"]
            }
        }
    },
    {
        name = "-dev-allow-health-check"
        action = "allow"
        description = ""
        direction = "INGRESS"
        disabled = false
        enable_logging = true
        firewall_policy = ""
        priority = 102
        match = {
            src_ip_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
            layer4_configs = {
                ip_protocol = "tcp"
            }
        }
    },
    {
        name = "-dev-allow-egress"
        action = "allow"
        description = ""
        direction = "EGRESS"
        disabled = false
        enable_logging = false
        firewall_policy = ""
        priority = 103
        match = {
            dest_ip_ranges = ["0.0.0.0/0"]
            layer4_configs = {
                ip_protocol = "tcp"
            }
        }
    }
]

lbipInfo = {
    name = "-dev-glb-lb-ip"
}

natipInfo = {
    name = "-dev-nat-gw-ip"
}

routerInfo  = {
    name = "-dev-router"
    routerNAT = {
        name = "-dev-router-nat-gw"
    }
}

artifactRegistryInfo = {
    name = "-dev-repo"
    description = "-dev dev repo"
    format = "DOCKER"
}

sqlInfo = {
    name = "-dev-mysql-db"
    instanceName = "-dev-mysql"
    version = "MYSQL_8_0_31"
    settings = {
        tier = "db-custom-2-8192"
        ipv4_enabled = true
    }
    protection = false
}

memstoreInfo = {
    name = "-dev-memstore"
    display_name = "-dev-memstore"
    tier  = "BASIC"
    sizeInGB = 1
}

fuseStorageInfo = {
    name = "-dev-fuse-stg"
    uniform_bucket_level_access = true
    force_destroy = true
    public_access_prevention = "enforced"
}

opsVMInfo = {
    name = "-dev-ops-vm"
    ip_name = "-dev-opsvm-pub-ip"
    machine_type = "n2d-standard-2"
    zone =  "asia-south1-a"
    boot_disk =  {
        image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
}