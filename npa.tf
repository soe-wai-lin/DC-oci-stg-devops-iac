resource "oci_vn_monitoring_path_analyzer_test" "airs_pod_to_redis_subnet_connectivity" {
  compartment_id = oci_identity_compartment.net_compartment.id
  display_name   = "${var.npa_display_name}-airs-pod-to-redis"
  protocol       = 6
  freeform_tags  = var.freeform_tags

  source_endpoint {
    type      = "SUBNET"
    subnet_id = oci_core_subnet.airs_micro_oke_pod_sub.id
    address   = var.airs_pod_source_ip
  }

  destination_endpoint {
    type      = "SUBNET"
    subnet_id = oci_core_subnet.db_sub.id
    address   = var.redis_destination_ip
  }

  protocol_parameters {
    type             = var.protocol
    destination_port = var.redis_destination_port
    source_port      = var.source_port
  }

  query_options {
    is_bi_directional_analysis = var.is_bi_directional_analysis
  }
}
resource "oci_vn_monitoring_path_analyzer_test" "airs_to_db_subnet_connectivity" {
  compartment_id = oci_identity_compartment.net_compartment.id
  display_name   = "${var.npa_display_name}-airs-to-db"
  protocol       = 6
  freeform_tags  = var.freeform_tags

  source_endpoint {
    type      = "SUBNET"
    subnet_id = oci_core_subnet.airs_micro_oke_worker_sub.id
    address   = var.airs_source_ip
  }

  destination_endpoint {
    type      = "SUBNET"
    subnet_id = oci_core_subnet.db_sub.id
    address   = var.db_destination_ip
  }

  protocol_parameters {
    type             = var.protocol
    destination_port = var.db_destination_port
    source_port      = var.source_port
  }

  query_options {
    is_bi_directional_analysis = var.is_bi_directional_analysis
  }
}
resource "oci_vn_monitoring_path_analyzer_test" "airs_pod_to_db_subnet_connectivity" {
  compartment_id = oci_identity_compartment.net_compartment.id
  display_name   = "${var.npa_display_name}-airs-pod-to-db"
  protocol       = 6
  freeform_tags  = var.freeform_tags

  source_endpoint {
    type      = "SUBNET"
    subnet_id = oci_core_subnet.airs_micro_oke_pod_sub.id
    address   = var.airs_pod_source_ip
  }

  destination_endpoint {
    type      = "SUBNET"
    subnet_id = oci_core_subnet.db_sub.id
    address   = var.db_destination_ip
  }

  protocol_parameters {
    type             = var.protocol
    destination_port = var.db_destination_port
    source_port      = var.source_port
  }

  query_options {
    is_bi_directional_analysis = var.is_bi_directional_analysis
  }
}
resource "oci_vn_monitoring_path_analyzer_test" "airs_to_redis_subnet_connectivity" {
  compartment_id = oci_identity_compartment.net_compartment.id
  display_name   = "${var.npa_display_name}-airs-to-redis"
  protocol       = 6
  freeform_tags  = var.freeform_tags

  source_endpoint {
    type      = "SUBNET"
    subnet_id = oci_core_subnet.airs_micro_oke_worker_sub.id
    address   = var.airs_source_ip
  }

  destination_endpoint {
    type      = "SUBNET"
    subnet_id = oci_core_subnet.db_sub.id  ### redis also use db subnet
    address   = var.redis_destination_ip
  }

  protocol_parameters {
    type             = var.protocol
    destination_port = var.redis_destination_port
    source_port      = var.source_port
  }

  query_options {
    is_bi_directional_analysis = var.is_bi_directional_analysis
  }
}

# resource "oci_vn_monitoring_path_analyzer_test" "cms_to_db_subnet_connectivity" {
#   compartment_id = oci_identity_compartment.net_compartment.id
#   display_name   = "${var.npa_display_name}-cms-to-db"
#   protocol       = 6
#   freeform_tags  = var.freeform_tags

#   source_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.cms_worker_sub.id
#     address   = var.cms_source_ip
#   }

#   destination_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.db_sub.id
#     address   = var.db_destination_ip
#   }

#   protocol_parameters {
#     type             = var.protocol
#     destination_port = var.db_destination_port
#     source_port      = var.source_port
#   }

#   query_options {
#     is_bi_directional_analysis = var.is_bi_directional_analysis
#   }
# }
# resource "oci_vn_monitoring_path_analyzer_test" "cms_pod_to_db_subnet_connectivity" {
#   compartment_id = oci_identity_compartment.net_compartment.id
#   display_name   = "${var.npa_display_name}-cms-pod-to-db"
#   protocol       = 6
#   freeform_tags  = var.freeform_tags

#   source_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.cms_worker_pod_sub.id
#     address   = var.cms_pod_source_ip
#   }

#   destination_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.db_sub.id
#     address   = var.db_destination_ip
#   }

#   protocol_parameters {
#     type             = var.protocol
#     destination_port = var.db_destination_port
#     source_port      = var.source_port
#   }

#   query_options {
#     is_bi_directional_analysis = var.is_bi_directional_analysis
#   }
# }

# resource "oci_vn_monitoring_path_analyzer_test" "web_to_db_subnet_connectivity" {
#   compartment_id = oci_identity_compartment.net_compartment.id
#   display_name   = "${var.npa_display_name}-web-to-db"
#   protocol       = 6
#   freeform_tags  = var.freeform_tags

#   source_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.web_worker_sub.id
#     address   = var.web_source_ip
#   }

#   destination_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.db_sub.id
#     address   = var.db_destination_ip
#   }

#   protocol_parameters {
#     type             = var.protocol
#     destination_port = var.db_destination_port
#     source_port      = var.source_port
#   }

#   query_options {
#     is_bi_directional_analysis = var.is_bi_directional_analysis
#   }
# }
# resource "oci_vn_monitoring_path_analyzer_test" "web_pod_to_db_subnet_connectivity" {
#   compartment_id = oci_identity_compartment.net_compartment.id
#   display_name   = "${var.npa_display_name}-web-pod-to-db"
#   protocol       = 6
#   freeform_tags  = var.freeform_tags

#   source_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.web_worker_pod_sub.id
#     address   = var.web_pod_source_ip
#   }

#   destination_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.db_sub.id
#     address   = var.db_destination_ip
#   }

#   protocol_parameters {
#     type             = var.protocol
#     destination_port = var.db_destination_port
#     source_port      = var.source_port
#   }

#   query_options {
#     is_bi_directional_analysis = var.is_bi_directional_analysis
#   }
# }

# resource "oci_vn_monitoring_path_analyzer_test" "web_to_redis_subnet_connectivity" {
#   compartment_id = oci_identity_compartment.net_compartment.id
#   display_name   = "${var.npa_display_name}-web-to-redis"
#   protocol       = 6
#   freeform_tags  = var.freeform_tags

#   source_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.web_worker_sub.id
#     address   = var.web_source_ip
#   }

#   destination_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.db_sub.id  ### redis also use db subnet
#     address   = var.redis_destination_ip
#   }

#   protocol_parameters {
#     type             = var.protocol
#     destination_port = var.redis_destination_port
#     source_port      = var.source_port
#   }

#   query_options {
#     is_bi_directional_analysis = var.is_bi_directional_analysis
#   }
# }
# resource "oci_vn_monitoring_path_analyzer_test" "web_pod_to_redis_subnet_connectivity" {
#   compartment_id = oci_identity_compartment.net_compartment.id
#   display_name   = "${var.npa_display_name}-web-pod-to-redis"
#   protocol       = 6
#   freeform_tags  = var.freeform_tags

#   source_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.web_worker_pod_sub.id
#     address   = var.web_pod_source_ip
#   }

#   destination_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.db_sub.id
#     address   = var.redis_destination_ip
#   }

#   protocol_parameters {
#     type             = var.protocol
#     destination_port = var.redis_destination_port
#     source_port      = var.source_port
#   }

#   query_options {
#     is_bi_directional_analysis = var.is_bi_directional_analysis
#   }
# }

# resource "oci_vn_monitoring_path_analyzer_test" "cms_to_redis_subnet_connectivity" {
#   compartment_id = oci_identity_compartment.net_compartment.id
#   display_name   = "${var.npa_display_name}-cms-to-redis"
#   protocol       = 6
#   freeform_tags  = var.freeform_tags

#   source_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.cms_worker_sub.id
#     address   = var.cms_source_ip
#   }

#   destination_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.db_sub.id  ### redis also use db subnet
#     address   = var.redis_destination_ip
#   }

#   protocol_parameters {
#     type             = var.protocol
#     destination_port = var.redis_destination_port
#     source_port      = var.source_port
#   }

#   query_options {
#     is_bi_directional_analysis = var.is_bi_directional_analysis
#   }
# }
# resource "oci_vn_monitoring_path_analyzer_test" "cms_pod_to_redis_subnet_connectivity" {
#   compartment_id = oci_identity_compartment.net_compartment.id
#   display_name   = "${var.npa_display_name}-cms-pod-to-redis"
#   protocol       = 6
#   freeform_tags  = var.freeform_tags

#   source_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.cms_worker_pod_sub.id
#     address   = var.cms_pod_source_ip
#   }

#   destination_endpoint {
#     type      = "SUBNET"
#     subnet_id = oci_core_subnet.db_sub.id
#     address   = var.redis_destination_ip
#   }

#   protocol_parameters {
#     type             = var.protocol
#     destination_port = var.redis_destination_port
#     source_port      = var.source_port
#   }

#   query_options {
#     is_bi_directional_analysis = var.is_bi_directional_analysis
#   }
# }





