projectInfo = {
        project = ""
        region = "asia-south1"
}

serviceAccountInfo = {
    name = "-sa@.iam.gserviceaccount.com"
}

services = [ "cloudresourcemanager.googleapis.com","compute.googleapis.com","orgpolicy.googleapis.com","container.googleapis.com","storage.googleapis.com","artifactregistry.googleapis.com","run.googleapis.com","aiplatform.googleapis.com","translate.googleapis.com","texttospeech.googleapis.com","vision.googleapis.com","apigee.googleapis.com","servicenetworking.googleapis.com","cloudkms.googleapis.com","mesh.googleapis.com","certificatemanager.googleapis.com","cloudbuild.googleapis.com","sqladmin.googleapis.com","redis.googleapis.com","secretmanager.googleapis.com"]

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
    },
    db_subnet = {
        name = "-dev-db-subnet",
        ip_cidr_range = "10.0.4.0/24"
    }
}

firewallPolicyInfo = {
    name = "-nw-policy"
    description = ""
}

firewallPolicyAssocInfo = {
    name = "-nw-policy-assoc"
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
        name = "-dev-allow-postgres"//firewall policy that will allow the traffic matching the rule
        action = "allow"
        description = ""
        direction = "INGRESS"  //The rule is for incoming traffic
        disabled = false
        enable_logging = false
        firewall_policy = ""
        priority = 103
        match = {  //rule is TCP traffic on port 5432 from any source IP address 0.0.0.0/0
            src_ip_ranges = ["0.0.0.0/0"]
            layer4_configs = {
                ip_protocol = "tcp"
                ports = ["5432"]
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
        priority = 104
        match = {
            dest_ip_ranges = ["0.0.0.0/0"]
            layer4_configs = {
                ip_protocol = "tcp"
            }
        }
    }
]

# dbInfo = {
#     name = 
#     instance =  "-pgsql"
# }

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
    description = " dev repo"
    format = "DOCKER"
}
//configuration/setting for Postgres SQL database. ie about the postgresSQL
sqlInfo = {
    name = "-pgsql-db"
    instanceName = "-pgsql"  //instance name
    version = "POSTGRES_14"  //version
    settings = {
        tier = "db-custom-2-8192"   //this is the 2-CPU and 8192 MB memory 
        ipv4_enabled = true  //ipv4 is enabled
    }
    protection = false
}

memstoreInfo = {
    name = "-memstore"
    display_name = "-memstore"
    tier  = "BASIC"
    sizeInGB = 1
}

fuseStorageInfo = {
    name = "-fuse-stg"
    uniform_bucket_level_access = true
    force_destroy = true
    public_access_prevention = "enforced"
}

opsVMInfo = {
    name = "-ops-vm"
    ip_name = "-opsvm-pub-ip"
    machine_type = "n2d-standard-2"
    zone =  "asia-south1-a"
    boot_disk =  {
        image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
}

secretInfo = {
    name = "-secret1"
}