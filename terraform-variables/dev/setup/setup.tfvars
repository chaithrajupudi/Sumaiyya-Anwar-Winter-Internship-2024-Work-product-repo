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
    opsvmIPName = "-dev-opsvm-pub-ip"
}

clusterInfo = {
    name = "-dev-cluster"
    initial_node = 1
    deletion_protection = false
    networking_mode = "VPC_NATIVE"
    release_channel = "STABLE"
    remove_default_pool = true
    network_policy = true
    pod_autoscale = true
    gcsfuse_csi = true
    private_cluster_config = null
    master_authorized_networks_config = null

    nodepool_config = [
    {
        name = "system-pool"
        machine_type = "e2-medium"
        initial_node = 1
        max_node = 2
        max_pods_per_node = 30
        min_node = 1
    },
    {
        name = "worker-pool"
        machine_type = "n2d-standard-2"
        initial_node = 1
        max_node = 5
        max_pods_per_node = 50
        min_node = 1
    }]
}