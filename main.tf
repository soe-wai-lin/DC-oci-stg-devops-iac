resource "oci_core_vcn" "terra_vcn" {
  #Required
  depends_on     = [oci_identity_compartment.net_compartment]
  compartment_id = oci_identity_compartment.net_compartment.id

  cidr_blocks   = var.vcn_cidr_block
  display_name  = var.vcn_display_name
  freeform_tags = var.freeform_tags
  dns_label     = var.vcn_dns_label
}

resource "oci_core_subnet" "lb_subnet" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id

  #Optional
  cidr_block    = var.lb_subnet_cidr
  display_name  = "${var.vcn_display_name}-lb-sub"
  freeform_tags = var.freeform_tags
  dns_label     = "publb"

  # Public subnet behavior
  prohibit_public_ip_on_vnic = false
  security_list_ids = [
    oci_core_security_list.pub_lb_SL.id
  ]
  route_table_id = oci_core_route_table.public_rt.id

}

resource "oci_core_subnet" "airs_micro_oke_worker_sub" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  dns_label = "worker"

  #Optional
  cidr_block    = var.airs_micro_oke_worker_cidr_block
  display_name  = "${var.vcn_display_name}-worker-sub"
  security_list_ids = [oci_core_security_list.airs_worker_SL.id]
  freeform_tags = var.freeform_tags

  # Public subnet behavior
  prohibit_public_ip_on_vnic = true
  # route_table_id             = oci_core_route_table.airs-workernodes-rt.id
  route_table_id             = oci_core_route_table.private_rt.id
}
resource "oci_core_subnet" "airs_micro_oke_pod_sub" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  dns_label = "pod"

  #Optional
  cidr_block    = var.airs_micro_oke_pod_cidr_block
  display_name  = "${var.vcn_display_name}-pod-sub"
  security_list_ids = [oci_core_security_list.airs_worker_pod_SL.id]
  freeform_tags = var.freeform_tags

  # Public subnet behavior
  prohibit_public_ip_on_vnic = true
  # route_table_id             = oci_core_route_table.routetable_airs_pods.id
  route_table_id             = oci_core_route_table.private_rt.id
}

resource "oci_core_subnet" "db_sub" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  dns_label      = "db"
  security_list_ids = [
    oci_core_security_list.redis_SL.id,
    oci_core_security_list.db_SL.id
  ]

  #Optional
  cidr_block    = var.db_cidr_block
  display_name  = "${var.vcn_display_name}-db-sub"
  freeform_tags = var.freeform_tags

  # Public subnet behavior
  prohibit_public_ip_on_vnic = true
  # route_table_id = oci_core_route_table.private_rt.id
}


resource "oci_core_subnet" "priv_lb_sub" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  dns_label = "privlb"

  #Optional
  cidr_block    = var.priv_lb_cidr_block
  display_name  = "${var.vcn_display_name}-priv-lb-sub"
  security_list_ids = [oci_core_security_list.priv_lb_SL.id]
  freeform_tags = var.freeform_tags

  # Public subnet behavior
  prohibit_public_ip_on_vnic = true
  route_table_id = oci_core_route_table.private_rt.id
}

resource "oci_core_subnet" "prod_k8s_priv_api_endpoint_sub" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  dns_label      = "privapi"

  #Optional
  cidr_block   = var.k8s_priv_api_endpoint_cidr_block
  display_name = "${var.vcn_display_name}-k8s_priv_api_endpoint_sub"
  security_list_ids = [oci_core_security_list.prod_k8s_priv_api_endpoint_SL.id]
  freeform_tags = var.freeform_tags

  # Public subnet behavior
  prohibit_public_ip_on_vnic = true
  # route_table_id             = oci_core_route_table.KubernetesAPIendpoint.id
  route_table_id             = oci_core_route_table.private_rt.id
}

############################
## Creating Security List ## 
############################

resource "oci_core_security_list" "redis_SL" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = "${var.vcn_display_name}-redis-sl"
  ingress_security_rules {
    protocol    = "6"
    source      = var.db_cidr_block
    source_type = "CIDR_BLOCK"
    description = "allow 6379 from db subnet"
    tcp_options {
      min = 6379
      max = 6379
    }
  }
  
  ingress_security_rules {
    protocol    = "6"
    source      = var.airs_micro_oke_worker_cidr_block
    source_type = "CIDR_BLOCK"
    description = "allow 6379 from airs subnet"
    tcp_options {
      min = 6379
      max = 6379
    }
  }
  ingress_security_rules {
    protocol    = "6"
    source      = var.airs_micro_oke_pod_cidr_block
    source_type = "CIDR_BLOCK"
    description = "allow 6379 from airs pod subnet"
    tcp_options {
      min = 6379
      max = 6379
    }
  }
  freeform_tags = var.freeform_tags
}

resource "oci_core_security_list" "prod_k8s_priv_api_endpoint_SL" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = "${var.vcn_display_name}-k8s-priv-api-endpoint-sl"
  freeform_tags = var.freeform_tags
}

resource "oci_core_security_list" "db_SL" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = "${var.vcn_display_name}-db-sl"

  ingress_security_rules {
    protocol    = "6"
    # source      = "10.10.96.0/20"
    source = var.airs_micro_oke_worker_cidr_block
    description = "allow_worker_to_db"
    tcp_options {
      min = 5432
      max = 5432
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source = var.airs_micro_oke_pod_cidr_block
    description = "allowpod_to_db"
    tcp_options {
      min = 5432
      max = 5432
    }
  }
  freeform_tags = var.freeform_tags

}

resource "oci_core_security_list" "airs_worker_SL" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = "${var.vcn_display_name}-worker-sl"
  # ingress_security_rules {
  #   protocol    = "6"
  #   # source      = "10.10.80.0/24"
  #   source = var.db_cidr_block
  #   description = "allow db to airs"
  # }
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Allow all egress"
  }

  freeform_tags = var.freeform_tags

}
resource "oci_core_security_list" "airs_worker_pod_SL" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = "${var.vcn_display_name}-pod-sl"
  freeform_tags = var.freeform_tags
  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
    description = "Allow all egress"
  }
}


resource "oci_core_security_list" "pub_lb_SL" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = "${var.vcn_display_name}-pub-lb-sl"
  # ingress_security_rules {
  #   protocol    = "6"
  #   source      = "0.0.0.0/0"
  #   description = "allow "
  #   tcp_options {
  #     max = 22
  #     min = 22
  #   }
  # }

  # ingress_security_rules {
  #   protocol    = "6"
  #   source      = "0.0.0.0/0"
  #   description = "allow "
  #   tcp_options {
  #     max = 80
  #     min = 80
  #   }
  # }

  freeform_tags = var.freeform_tags

}

resource "oci_core_security_list" "priv_lb_SL" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = "${var.vcn_display_name}-priv-lb-sl"
  # ingress_security_rules {
  #   protocol    = "6"
  #   source      = "0.0.0.0/0"
  #   description = "allow"
  # }
  # egress_security_rules {
  #   protocol    = "all"
  #   destination = "0.0.0.0/0"
  #   description = "Allow all egress"
  # }

  freeform_tags = var.freeform_tags

}

## Creating NSG ##

#######################
###### NSG LB      ####
#######################

resource "oci_core_network_security_group" "nsg_prod_lb" {
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = var.nsg_lb
}
# INGRESS: 
resource "oci_core_network_security_group_security_rule" "nsg_prod_lb_ingress_443" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_lb.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Allow inbound traffic to Load Balancer."

  # Optional: Restrict to ping only (echo request = type 8)
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "nsg_prod_lb_ingress_80" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_lb.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Allow inbound traffic to Load Balancer."

  # Optional: Restrict to ping only (echo request = type 8)
  tcp_options {
    destination_port_range {
      min = 80
      max = 80
    }
  }
}

resource "oci_core_network_security_group_security_rule" "nsg_prod_lb_ingress_prometheus_9090" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_lb.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Allow prometheus port to Load Balancer."

  # Optional: Restrict to ping only (echo request = type 8)
  tcp_options {
    destination_port_range {
      min = 9090
      max = 9090
    }
  }
}

# For multiple egress target , create "local" data

locals {
  lb_egress_targets = {
    airs = { id = oci_core_network_security_group.nsg_prod_airs.id }
  }
}

# EGRESS: 
resource "oci_core_network_security_group_security_rule" "nsg_prod_lb_egress" {
  for_each                  = local.lb_egress_targets
  network_security_group_id = oci_core_network_security_group.nsg_prod_lb.id
  direction                 = "EGRESS"
  protocol                  = "6"
  # destination               = "0.0.0.0/0"
  # destination_type          = "CIDR_BLOCK"
  destination_type = "NETWORK_SECURITY_GROUP"
  destination      = each.value.id

  description = "Allow LB to ${each.key}"
}

resource "oci_core_network_security_group_security_rule" "nsg_prod_lb_airs_worker_egress" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_lb.id
  direction                 = "EGRESS"
  protocol                  = "6"
  # destination               = "10.10.96.0/20"
  destination = var.airs_micro_oke_worker_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Allow traffic to cms worker nodes."
  tcp_options {
    destination_port_range {
      min = 30000
      max = 32767
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_lb_airs_worker_proxy_egress" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_lb.id
  direction                 = "EGRESS"
  protocol                  = "6"
  # destination               = "10.10.96.0/20"
  destination = var.airs_micro_oke_worker_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Allow OCI load balancer or network load balancer to communicate with kube-proxy on worker nodes"
  tcp_options {
    destination_port_range {
      min = 10256
      max = 10256
    }
  }
}

resource "oci_core_network_security_group_security_rule" "nsg_prod_lb_gfhost" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_lb.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  # destination = var.airs_micro_oke_worker_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Allow to install yum update port 443"
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_lb_gfhost_3000" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_lb.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  # destination = var.airs_micro_oke_worker_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Allow to access grafana port 3000"
  tcp_options {
    destination_port_range {
      min = 3000
      max = 3000
    }
  }
}

###########################
##### NSG AIRS WORKER  ####
###########################

resource "oci_core_network_security_group" "nsg_prod_airs" {
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = var.nsg_airs
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_ingress_worker" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "INGRESS"
  protocol                  = "all"
  # source                    = "10.10.96.0/20"
  source = var.airs_micro_oke_worker_cidr_block
  source_type               = "CIDR_BLOCK"
  description               = "Allows communication from (or to) worker nodes."
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_ingress_pod" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "INGRESS"
  protocol                  = "all"
  # source                    = "10.10.144.0/20"
  source = var.airs_micro_oke_pod_cidr_block
  source_type               = "CIDR_BLOCK"
  description               = "Allow pods on one worker node to communicate with pods on other worker nodes (when using VCN-native pod networking)."
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_ingress_icmp" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "INGRESS"
  protocol                  = "1"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Path Discovery."
  icmp_options {
    type = 3
    code = 4
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_ingress_api_ep_all" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "INGRESS"
  protocol                  = "6"
  # source                    = "10.10.60.0/24"
  source = var.k8s_priv_api_endpoint_cidr_block
  source_type               = "CIDR_BLOCK"
  description               = "Allow Kubernetes API endpoint to communicate with worker nodes."
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_ingress_api_ep_10250" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "INGRESS"
  protocol                  = "6"
  # source                    = "10.10.60.0/24"
  source = var.k8s_priv_api_endpoint_cidr_block
  source_type               = "CIDR_BLOCK"
  description               = "Kubernetes API endpoint to worker node communication (when using VCN-native pod networking)."
  tcp_options {
    destination_port_range {
      min = 10250
      max = 10250
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_ingress_ssh" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = oci_core_network_security_group.nsg_prod_bastion.id
  source_type               = "NETWORK_SECURITY_GROUP"
  description               = "(optional) Allow inbound SSH traffic from Bastion to worker nodes."
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_ingress_all_from_anywhere" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "LB or anywhere to worker"
  tcp_options {
    destination_port_range {
      min = 30000
      max = 32767
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_ingress_lb" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "INGRESS"
  protocol                  = "6"
  # source                    = "10.10.0.0/24"
  source = var.lb_subnet_cidr
  source_type               = "CIDR_BLOCK"
  description               = "Allow OCI load balancer or network load balancer to communicate with kube-proxy on worker nodes."
  tcp_options {
    destination_port_range {
      min = 10256
      max = 10256
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_ingress_icmp_from_bastion" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "INGRESS"
  protocol                  = "1" # ICMP
  source                    = oci_core_network_security_group.nsg_prod_bastion.id
  source_type               = "NETWORK_SECURITY_GROUP"
  stateless                 = false
  description               = "Allow Ping from Bastion NSG"
}

# EGRESS
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_egress" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "EGRESS"
  protocol                  = "all"
  # destination               = "10.10.80.0/24"
  destination = var.db_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Allow to db_subnet"
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_egress_worker" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "EGRESS"
  protocol                  = "all"
  # destination               = "10.10.96.0/20"
  destination = var.airs_micro_oke_worker_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Allows communication from (or to) worker nodes."
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_egress_pod" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "EGRESS"
  protocol                  = "all"
  # destination               = "10.10.144.0/20"
  destination = var.airs_micro_oke_pod_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Allow worker nodes to communicate with pods on other worker nodes (when using VCN-native pod networking)."
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_egress_icmp" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "EGRESS"
  protocol                  = "1"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  description               = "Path Discovery."
  icmp_options {
    type = 3
    code = 4
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_egress_api_ep_6443" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "EGRESS"
  protocol                  = "6"
  # destination               = "10.10.60.0/24"
  destination = var.k8s_priv_api_endpoint_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Kubernetes worker to Kubernetes API endpoint communication."
  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_egress_api_worker_allow_to_internet" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  description               = "(optional) Allow worker nodes to communicate with internet."
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_egress_api_ep_12250" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "EGRESS"
  protocol                  = "6"
  # destination               = "10.10.60.0/24"
  destination = var.k8s_priv_api_endpoint_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Kubernetes worker to Kubernetes API endpoint communication."
  tcp_options {
    destination_port_range {
      min = 12250
      max = 12250
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_engress_osn" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs.id
  direction                 = "EGRESS"
  protocol                  = "6"
  stateless                 = false
  tcp_options {}
  destination      = data.oci_core_services.services.services[0].cidr_block
  destination_type = "SERVICE_CIDR_BLOCK"
  description      = "Allow nodes to communicate with OKE."
}


####################
### AIRS POD NSG ####
####################
resource "oci_core_network_security_group" "nsg_prod_airs_pod" {
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = var.nsg_airs_pod
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_pod_k8s_api_ep_ingress" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs_pod.id
  direction                 = "INGRESS"
  protocol                  = "all"
  # source                    = "10.10.60.0/24"
  source = var.k8s_priv_api_endpoint_cidr_block
  source_type               = "CIDR_BLOCK"
  description               = "Kubernetes API endpoint to pod communication (when using VCN-native pod networking)."
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_pod_woker_ingress" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs_pod.id
  direction                 = "INGRESS"
  protocol                  = "all"
  # source                    = "10.10.96.0/20"
  source = var.airs_micro_oke_worker_cidr_block
  source_type               = "CIDR_BLOCK"
  description               = "Allow pods on one worker node to communicate with pods on other worker nodes."
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_pod_ingress" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs_pod.id
  direction                 = "INGRESS"
  protocol                  = "all"
  # source                    = "10.10.144.0/20"
  source = var.airs_micro_oke_pod_cidr_block
  source_type               = "CIDR_BLOCK"
  description               = "Allow pods to communicate with each other."
}

# Egress
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_pod_egress" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs_pod.id
  direction                 = "EGRESS"
  protocol                  = "all"
  # destination               = "10.10.144.0/20"
  destination = var.airs_micro_oke_pod_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Allow pods to communicate with each other."
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_pod_egress_osn" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs_pod.id
  direction                 = "EGRESS"
  protocol                  = "6"
  tcp_options {}
  stateless        = false
  destination      = data.oci_core_services.services.services[0].cidr_block
  destination_type = "SERVICE_CIDR_BLOCK"
  description      = "Allow worker nodes to communicate with OCI services."
}

resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_pod_egress_icmp" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs_pod.id
  direction                 = "EGRESS"
  protocol                  = "1" # ICMP
  destination               = data.oci_core_services.services.services[0].cidr_block
  destination_type          = "SERVICE_CIDR_BLOCK"
  stateless                 = false
  description               = "Path MTU Discovery from worker nodes (ICMP type 3 code 4)."

  icmp_options {
    type = 3
    code = 4
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_pod_egress10250" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs_pod.id
  direction                 = "EGRESS"
  protocol                  = "6"
  # destination               = "10.10.60.0/24"
  destination = var.k8s_priv_api_endpoint_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Pod to Kubernetes API endpoint communication (when using VCN-native pod networking)."
  tcp_options {
    destination_port_range {
      min = 12250
      max = 12250
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_pod_egress_6443" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs_pod.id
  direction                 = "EGRESS"
  protocol                  = "6"
  # destination               = "10.10.60.0/24"
  destination = var.k8s_priv_api_endpoint_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Pod to Kubernetes API endpoint communication (when using VCN-native pod networking)."
  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_airs_pod_egress_443" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_airs_pod.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  description               = "(optional) Allow pods to communicate with internet."
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}


####################
### Bastion NSG  ###
####################
resource "oci_core_network_security_group" "nsg_prod_bastion" {
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = var.nsg_bastion
}

# INGRESS: ssh from anywhere
resource "oci_core_network_security_group_security_rule" "nsg_prod_bastion_ingress" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_bastion.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Allow ssh from anywhere"

  # Optional: Restrict to ping only (echo request = type 8)
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}


# EGRESS: Allow all 
resource "oci_core_network_security_group_security_rule" "nsg_prod_bastion_egress_k8s_api" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_bastion.id
  direction                 = "EGRESS"
  protocol                  = "6"
  # destination               = "10.10.60.0/24"
  destination = var.k8s_priv_api_endpoint_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Allow access to k8s API endpoints"
  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_bastion_egress_to_db" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_bastion.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination = var.db_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Allow access to DB subnet"
  tcp_options {
    destination_port_range {
      min = 5432
      max = 5432
    }
  }
}

resource "oci_core_network_security_group_security_rule" "nsg_prod_bastion_egress_airs_worker" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_bastion.id
  direction                 = "EGRESS"
  protocol                  = "6"
  # destination               = "10.10.96.0/20"
  destination = var.airs_micro_oke_worker_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "SSH access to AIRS Worker Nodes"
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

####################
### GFhsot NSG  ###
####################
resource "oci_core_network_security_group" "nsg_prod_gfhost" {
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = var.nsg_gf_host
}

# INGRESS: ssh from anywhere
resource "oci_core_network_security_group_security_rule" "nsg_prod_gfhost_ingress" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_gfhost.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Allow ssh from anywhere"

  # Optional: Restrict to ping only (echo request = type 8)
  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_gfhost_ingress_3000" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_gfhost.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Allow Grafana port 3000 from anywhere"

  # Optional: Restrict to ping only (echo request = type 8)
  tcp_options {
    destination_port_range {
      min = 3000
      max = 3000
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_gfhost_ingress_443" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_gfhost.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Allow Grafana port 443 from anywhere"

  # Optional: Restrict to ping only (echo request = type 8)
  tcp_options {
    destination_port_range {
      min = 443
      max = 443
    }
  }
}


# EGRESS: Allow all 
resource "oci_core_network_security_group_security_rule" "nsg_prod_gfhost_egress_all" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_gfhost.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  # destination = var.k8s_priv_api_endpoint_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Allow allow access to everywhere"
  tcp_options {
    # destination_port_range {
    #   min = 6443
    #   max = 6443
    # }
  }
}

####################
#### NSG DB  #######
####################
resource "oci_core_network_security_group" "nsg_prod_db" {
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = var.nsg_db
}

resource "oci_core_network_security_group_security_rule" "nsg_prod_db_ingress_from_airs_worker" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_db.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.airs_micro_oke_worker_cidr_block
  source_type               = "CIDR_BLOCK"
  description               = "Allow 5432 from AIRS worker"

  # Optional: Restrict to ping only (echo request = type 8)
  tcp_options {
    destination_port_range {
      min = 5432
      max = 5432
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_db_ingress_from_bastion" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_db.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = oci_core_network_security_group.nsg_prod_bastion.id
  source_type               = "NETWORK_SECURITY_GROUP"
  description               = "Allow 5432 from Bastion"

  # Optional: Restrict to ping only (echo request = type 8)
  tcp_options {
    destination_port_range {
      min = 5432
      max = 5432
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_db_ingress_from_airs_pod" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_db.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.airs_micro_oke_pod_cidr_block
  source_type               = "CIDR_BLOCK"
  description               = "Allow 5432 from AIRS pod"

  # Optional: Restrict to ping only (echo request = type 8)
  tcp_options {
    destination_port_range {
      min = 5432
      max = 5432
    }
  }
}
# EGRESS: Allow all 
resource "oci_core_network_security_group_security_rule" "nsg_prod_db_egress" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_db.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  # destination      = oci_core_network_security_group.nsg_prod_airs.id
  # destination_type = "NETWORK_SECURITY_GROUP"
  description      = "Allow to all"

  tcp_options { }
}

#########################
##### NSG Redis      ####
#########################
resource "oci_core_network_security_group" "nsg_prod_redis" {
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = var.nsg_redis
}

resource "oci_core_network_security_group_security_rule" "nsg_prod_redis_ingress_from_airs_worker" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_redis.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.airs_micro_oke_worker_cidr_block
  source_type               = "CIDR_BLOCK"
  description               = "Allow 6379 from AIRS worker"

  # Optional: Restrict to ping only (echo request = type 8)
  tcp_options {
    destination_port_range {
      min = 6379
      max = 6379
    }
  }
}
resource "oci_core_network_security_group_security_rule" "nsg_prod_redis_ingress_from_airs_pod" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_redis.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = var.airs_micro_oke_pod_cidr_block
  source_type               = "CIDR_BLOCK"
  description               = "Allow 6379 from AIRS pod"

  # Optional: Restrict to ping only (echo request = type 8)
  tcp_options {
    destination_port_range {
      min = 6379
      max = 6379
    }
  }
}
# EGRESS: Allow all 
resource "oci_core_network_security_group_security_rule" "nsg_prod_redis_egress" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_redis.id
  direction                 = "EGRESS"
  protocol                  = "6"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  # destination      = oci_core_network_security_group.nsg_prod_airs.id
  # destination_type = "NETWORK_SECURITY_GROUP"
  description      = "Allow to all"

  tcp_options { }
}


##############################
#### NSG for OKE          ####
##############################

resource "oci_core_network_security_group" "nsg_prod_k8s_api_endpoints" {
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = var.nsg_k8s_api_endpoint
}

locals {
  k8s_api_ep = {
    airs_worker_6443  = { cidr = var.airs_micro_oke_worker_cidr_block, port = "6443" }
    airs_worker_12250 = { cidr = var.airs_micro_oke_worker_cidr_block, port = "12250" }
    airs_pod_6443     = { cidr = var.airs_micro_oke_pod_cidr_block, port = "6443" }
    airs_pod_12250    = { cidr = var.airs_micro_oke_pod_cidr_block, port = "12250" }
  }
}

# INGRESS 
resource "oci_core_network_security_group_security_rule" "nsg_prod_k8s_api_endpoints_ingress" {
  for_each                  = local.k8s_api_ep
  network_security_group_id = oci_core_network_security_group.nsg_prod_k8s_api_endpoints.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = each.value.cidr
  source_type               = "CIDR_BLOCK"
  description               = "Kubernetes ${each.key} to Kubernetes API endpoint communication."

  tcp_options {
    destination_port_range {
      min = each.value.port
      max = each.value.port
    }
  }
}

resource "oci_core_network_security_group_security_rule" "nsg_prod_k8s_api_endpoints_airs_ingress_icmp" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_k8s_api_endpoints.id
  direction                 = "INGRESS"
  protocol                  = "1" # ICMP
  # source                    = "10.10.96.0/20"
  source = var.airs_micro_oke_worker_cidr_block
  source_type               = "CIDR_BLOCK"
  stateless                 = false
  description               = "Path MTU Discovery from airs worker nodes (ICMP type 3 code 4)."

  icmp_options {
    type = 3
    code = 4
  }
}

resource "oci_core_network_security_group_security_rule" "nsg_prod_k8s_api_endpoints_ingress_all" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_k8s_api_endpoints.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  stateless                 = false
  description               = "Client access to Kubernetes API endpoint"

  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}

# EGRESS: 
resource "oci_core_network_security_group_security_rule" "nsg_prod_k8s_api_endpoints_ingress_osn_443" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_k8s_api_endpoints.id
  direction                 = "EGRESS"
  protocol                  = "6"
  stateless                 = false
  destination               = data.oci_core_services.services.services[0].cidr_block
  destination_type          = "SERVICE_CIDR_BLOCK"
  description               = "Allow Kubernetes API endpoint to communicate with OKE."

  tcp_options {
    destination_port_range {
      max = 443
      min = 443
    }
  }
}

resource "oci_core_network_security_group_security_rule" "k8s_api_endpoint_egress_airs_pod_tcp_all" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_k8s_api_endpoints.id
  direction                 = "EGRESS"
  protocol                  = "all"
  stateless                 = false
  # destination               = "10.10.144.0/20"
  destination = var.airs_micro_oke_pod_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Kubernetes API endpoint to airs pod communication (when using VCN-native pod networking)"
}
resource "oci_core_network_security_group_security_rule" "k8s_api_endpoint_egress_airs_worker_tcp_10250" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_k8s_api_endpoints.id
  direction                 = "EGRESS"
  protocol                  = "6" # TCP
  stateless                 = false
  # destination               = "10.10.96.0/20"
  destination = var.airs_micro_oke_worker_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Kubernetes API endpoint to airs worker node communication over TCP/10250 (when using VCN-native pod networking)."
  tcp_options {
    destination_port_range {
      min = 10250
      max = 10250
    }
  }
}
resource "oci_core_network_security_group_security_rule" "k8s_api_endpoint_egress_airs_worker_icmp_3_4" {
  network_security_group_id = oci_core_network_security_group.nsg_prod_k8s_api_endpoints.id
  direction                 = "EGRESS"
  protocol                  = "1" # ICMP
  stateless                 = false
  # destination               = "10.10.96.0/20"
  destination = var.airs_micro_oke_worker_cidr_block
  destination_type          = "CIDR_BLOCK"
  description               = "Path Discovery (ICMP type 3 code 4) to cms worker nodes."

  icmp_options {
    type = 3
    code = 4
  }
}

## Creating IGW and NAT Gateway##

resource "oci_core_internet_gateway" "igw" {
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id

  display_name = "${var.vcn_display_name}-igw"
  enabled      = true

  freeform_tags = var.freeform_tags
}


# Reserved (Regional) Public IP
# ----------------------------
resource "oci_core_public_ip" "nat_reserved_ip" {
  compartment_id = oci_identity_compartment.net_compartment.id
  lifetime       = "RESERVED"

  lifecycle {
    ignore_changes = [private_ip_id]
  }

  display_name  = "${var.vcn_display_name}-nat-reserved-ip"
  freeform_tags = var.freeform_tags
}


# resource "oci_core_public_ip" "airs_cluster_lb_reserved_ip" {
#   compartment_id = oci_identity_compartment.net_compartment.id
#   lifetime       = "RESERVED"

#   lifecycle {
#     ignore_changes = [private_ip_id]
#   }

#   display_name  = "${var.vcn_display_name}-cluster-lb-reserved-ip"
#   freeform_tags = var.freeform_tags
# }

resource "oci_core_nat_gateway" "nat" {
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id
  display_name   = "${var.vcn_display_name}-nat"
  depends_on     = [oci_core_public_ip.nat_reserved_ip]
  
  # Attach the reserved IP here
  public_ip_id = oci_core_public_ip.nat_reserved_ip.id


  freeform_tags = var.freeform_tags
}

###############################################
## Creating Public and Private Routing Table ##
###############################################

resource "oci_core_route_table" "public_rt" {
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id

  display_name = "${var.vcn_display_name}-public-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.igw.id
    description       = "Public subnet default route via Internet Gateway"
  }

  freeform_tags = var.freeform_tags
}

resource "oci_core_route_table" "private_rt" {
  compartment_id = oci_identity_compartment.net_compartment.id
  vcn_id         = oci_core_vcn.terra_vcn.id

  display_name = "${var.vcn_display_name}-private-rt"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_nat_gateway.nat.id
    description       = "Private subnet default route via NAT Gateway"
  }

  route_rules {
    destination       = data.oci_core_services.services.services[0].cidr_block
    destination_type  = "SERVICE_CIDR_BLOCK"
    network_entity_id = oci_core_service_gateway.service_gateway.id
    description       = "Private subnet default route via NAT Gateway"
  }

  freeform_tags = var.freeform_tags
}


data "oci_core_services" "services" {}

resource "oci_core_service_gateway" "service_gateway" {
  #Required
  compartment_id = oci_identity_compartment.net_compartment.id
  services {
    #Required
    service_id = data.oci_core_services.services.services[0].id
  }
  vcn_id = oci_core_vcn.terra_vcn.id

  #Optional
  display_name  = "${var.vcn_display_name}-service-gateway"
  freeform_tags = var.freeform_tags
  # route_table_id = oci_core_route_table.test_route_table.id
}
