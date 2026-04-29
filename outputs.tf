output "stg_internet_gateway_id" {
  value = oci_core_internet_gateway.igw.id
}

output "stg_nat_gateway_id" {
  value = oci_core_nat_gateway.nat.id
}

output "stg_nat_gateway_reserved_ip" {
  value = oci_core_nat_gateway.nat.nat_ip
}

output "stg_public_route_table_id" {
  value = oci_core_route_table.public_rt.id
}

output "stg_private_route_table_id" {
  value = oci_core_route_table.private_rt.id
}

output "stg_vcn_id" {
  value = oci_core_vcn.terra_vcn.id
}

output "stg_net_compartment_id" {
  value       = oci_identity_compartment.net_compartment.id
  description = "net_compartment_id"
}

output "stg_app_compartment_id" {
  value       = oci_identity_compartment.app_compartment.id
  description = "app_compartment_id"
}

output "stg_db_compartment_id" {
  value       = oci_identity_compartment.data_compartment.id
  description = "db_compartment_id"
}

output "stg_vcn_name" {
  value = oci_core_vcn.terra_vcn.display_name
}


# ##################
# #### Database  ###
# ##################

# # output "postgres_db_system_id" {
# #   value = oci_psql_db_system.postgresql.id
# # }

# # output "postgres_db_system_state" {
# #   value = oci_psql_db_system.postgresql.state
# # }

# # output "postgres_admin_username" {
# #   value = oci_psql_db_system.postgresql.admin_username
# # }

# # output "alert_name" {
# #   value = oci_ons_notification_topic.network_alert_topic.name
# # }

# # output "alert_mail" {
# #   value = oci_ons_subscription.email_subscription.endpoint
# # }


####################
### Redis        ###
####################

output "redis_cluster_id" {
  description = "OCID of the Redis cluster."
  value       = oci_redis_redis_cluster.redis.id
}

output "redis_cluster_display_name" {
  description = "Display name of the Redis cluster."
  value       = data.oci_redis_redis_cluster.redis.display_name
}

output "redis_cluster_mode" {
  description = "Redis cluster mode."
  value       = data.oci_redis_redis_cluster.redis.cluster_mode
}

output "redis_primary_fqdn" {
  description = "Primary node FQDN."
  value       = try(data.oci_redis_redis_cluster.redis.primary_fqdn, null)
}

output "redis_primary_ip" {
  description = "Primary node private IP."
  value       = try(data.oci_redis_redis_cluster.redis.primary_endpoint_ip_address, null)
}

output "redis_discovery_fqdn" {
  description = "Discovery FQDN for sharded clusters."
  value       = try(data.oci_redis_redis_cluster.redis.discovery_fqdn, null)
}

output "redis_discovery_ip" {
  description = "Discovery IP for sharded clusters."
  value       = try(data.oci_redis_redis_cluster.redis.discovery_endpoint_ip_address, null)
}

output "redis_node_endpoints" {
  description = "List of per-node private endpoints."
  value = [
    for node in try(data.oci_redis_redis_cluster.redis.node_collection[0].items, []) : {
      display_name                = try(node.display_name, null)
      private_endpoint_fqdn       = try(node.private_endpoint_fqdn, null)
      private_endpoint_ip_address = try(node.private_endpoint_ip_address, null)
    }
  ]
}


##################
##  Bucket      ##
##################

output "stg_namespace" {
  description = "Object Storage namespace used for the bucket."
  value       = data.oci_objectstorage_namespace.ns.namespace
}

output "stg_bucket_name" {
  description = "Bucket name."
  value       = oci_objectstorage_bucket.bucket.name
}

output "stg_bucket_id" {
  description = "Bucket identifier returned by OCI."
  value       = data.oci_objectstorage_bucket.bucket.bucket_id
}

output "stg_bucket_access_type" {
  description = "Configured public access type."
  value       = data.oci_objectstorage_bucket.bucket.access_type
}

output "stg_bucket_storage_tier" {
  description = "Configured storage tier."
  value       = data.oci_objectstorage_bucket.bucket.storage_tier
}

output "stg_bucket_versioning" {
  description = "Bucket versioning status."
  value       = data.oci_objectstorage_bucket.bucket.versioning
}

output "stg_bucket_approximate_size" {
  description = "Approximate total size in bytes of all objects in the bucket."
  value       = data.oci_objectstorage_bucket.bucket.approximate_size
}

# ##############
# ### Vault  ###
# ##############

# # output "vault_id" {
# #   description = "OCID of the OCI KMS vault."
# #   value       = oci_kms_vault.vault.id
# # }

# # output "vault_name" {
# #   description = "Display name of the vault."
# #   value       = data.oci_kms_vault.vault.display_name
# # }

# # output "management_endpoint" {
# #   description = "KMS management endpoint for key and vault management operations."
# #   value       = data.oci_kms_vault.vault.management_endpoint
# # }

# # output "crypto_endpoint" {
# #   description = "KMS crypto endpoint for encrypt/decrypt operations."
# #   value       = data.oci_kms_vault.vault.crypto_endpoint
# # }

# # output "is_primary" {
# #   description = "Whether this vault is the primary vault."
# #   value       = data.oci_kms_vault.vault.is_primary
# # }


# # output "auto_key_rotation" {
# #   value = try({
# #     last_rotation_message     = data.oci_kms_key.secret_key.auto_key_rotation_details[0].last_rotation_message
# #     last_rotation_status      = data.oci_kms_key.secret_key.auto_key_rotation_details[0].last_rotation_status
# #     rotation_interval_in_days = data.oci_kms_key.secret_key.auto_key_rotation_details[0].rotation_interval_in_days
# #     time_of_last_rotation     = data.oci_kms_key.secret_key.auto_key_rotation_details[0].time_of_last_rotation
# #     time_of_next_rotation     = data.oci_kms_key.secret_key.auto_key_rotation_details[0].time_of_next_rotation
# #     time_of_schedule_start    = data.oci_kms_key.secret_key.auto_key_rotation_details[0].time_of_schedule_start
# #   }, null)
# # }

# ##################################
# ###### Network Path Analyzer   ###
# ##################################

output "airs_to_redis_npa_test_id" {
  value = oci_vn_monitoring_path_analyzer_test.airs_to_redis_subnet_connectivity.id
}

output "airs_pod_to_redis_npa_test_id" {
  value = oci_vn_monitoring_path_analyzer_test.airs_pod_to_redis_subnet_connectivity.id
}
output "airs_to_db_npa_test_id" {
  value = oci_vn_monitoring_path_analyzer_test.airs_to_db_subnet_connectivity.id
}
output "airs_pod_to_db_npa_test_id" {
  value = oci_vn_monitoring_path_analyzer_test.airs_pod_to_db_subnet_connectivity.id
}
# output "web_pod_to_db_npa_test_id" {
#   value = oci_vn_monitoring_path_analyzer_test.web_pod_to_db_subnet_connectivity.id
# }
# output "web_to_db_npa_test_id" {
#   value = oci_vn_monitoring_path_analyzer_test.web_to_db_subnet_connectivity.id
# }

# output "cms_to_db_npa_test_id" {
#   value = oci_vn_monitoring_path_analyzer_test.cms_to_db_subnet_connectivity.id
# }

# output "cms_pod_to_db_npa_test_id" {
#   value = oci_vn_monitoring_path_analyzer_test.cms_pod_to_db_subnet_connectivity.id
# }



# # output "web_to_cms_npa_test_id" {
# #   value = oci_vn_monitoring_path_analyzer_test.web_to_cms_subnet_connectivity.id
# # }

# # output "cms_to_web_npa_test_id" {
# #   value = oci_vn_monitoring_path_analyzer_test.cms_to_web_subnet_connectivity.id
# # }

# output "web_to_redis_npa_test_id" {
#   value = oci_vn_monitoring_path_analyzer_test.web_to_redis_subnet_connectivity.id
# }

# output "web_pod_to_redis_npa_test_id" {
#   value = oci_vn_monitoring_path_analyzer_test.web_pod_to_redis_subnet_connectivity.id
# }

# output "cms_to_redis_npa_test_id" {
#   value = oci_vn_monitoring_path_analyzer_test.cms_to_redis_subnet_connectivity.id
# }

# output "cms_pod_to_redis_npa_test_id" {
#   value = oci_vn_monitoring_path_analyzer_test.cms_pod_to_redis_subnet_connectivity.id
# }



# ################
# ##    OKE    ###
# ################

output "airs_oke_cluster_ocid" {
  description = "AIRS OKE cluster OCID"
  value       = oci_containerengine_cluster.stg_oke.id
}
output "stg_lb_subnet_ocid" {
  description = "Load balancer subnet OCID"
  value       = oci_core_subnet.lb_subnet.id
}
output "stg_lb_nsg_ocid" {
  description = "PROD Load balancer NSG OCID"
  value       = oci_core_network_security_group.nsg_prod_lb.id
}
output "stg_bastion_public_ip" {
  value = oci_core_instance.bastion.public_ip
}
output "stg_lb_reserved_public_ip_ocid" {
  description = "AIRS Reserved public IP OCID for the OKE load balancer"
  value       = oci_core_public_ip.airs_cluster_lb_reserved_ip.ip_address
}
# # output "cms_oke_cluster_ocid" {
# #   description = "CMS OKE cluster OCID"
# #   value       = oci_containerengine_cluster.cms_oke.id
# # }
# # output "system_node_image_id" {
# #   value = local.system_node_image_id
# # }

# # output "worker_node_image_id" {
# #   value = local.worker_node_image_id
# # }

# # output "web_oke_cluster_ocid" {
# #   description = "WEB OKE cluster OCID"
# #   value       = oci_containerengine_cluster.web_oke.id
# # }

# output "apisix_oke_cluster_ocid" {
#   description = "APISIX OKE cluster OCID"
#   value       = oci_containerengine_cluster.apisix_oke.id
# }
# output "stg_web_lb_reserved_public_ip_ocid" {
#   description = "WEB Reserved public IP OCID for the OKE load balancer"
#   value       = oci_core_public_ip.web_cluster_lb_reserved_ip.ip_address
# }

# # output "pre_prod_cms_lb_reserved_public_ip_ocid" {
# #   description = "CMS Reserved public IP OCID for the OKE load balancer"
# #   value       = oci_core_public_ip.cms_cluster_lb_reserved_ip.ip_address
# # }

output "pre_prod_airs_lb_reserved_public_ip_ocid" {
  description = "AIRS Reserved public IP OCID for the OKE load balancer"
  value       = oci_core_public_ip.airs_cluster_lb_reserved_ip.ip_address
}

# output "stg_apisix_lb_reserved_public_ip_ocid" {
#   description = "AIRS Reserved public IP OCID for the OKE load balancer"
#   value       = oci_core_public_ip.apisix_cluster_lb_reserved_ip.ip_address
# }







