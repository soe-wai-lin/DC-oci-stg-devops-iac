################################
### Infra Setup              ###
################################


variable "home_region" {
  default = "ap-singapore-1"
}

variable "resource_region" {
  default = "ap-singapore-1"
}

# variable "target_region" {
#   default = "ap-sydney-1"
# }


variable "compartment_id" {
  default     = "ocid1.compartment.oc1..aaaaaaaarfcxj755zm6namwjijmg426pve3qlqrtfls6egmutvemkm2vvloa"
  description = "staging compartment, this compartment id will be used to create subcompartment like app, data, mgmt, network"
}

variable "vcn_display_name" {
  default = "DC-TW-VCN"
  type    = string
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags"
  default = {
    Environment = "stg"
    Managed_by  = "Terraform"
  }
}

variable "vcn_cidr_block" {
  default = ["10.30.0.0/16"]
  type    = list(string)
}

variable "vcn_dns_label" {
  default = "stg"
  type    = string
}

variable "lb_subnet_cidr" {
  default = "10.30.0.0/24"
}

# variable "cms_worker_sub_cidr" {
#   default = "10.30.16.0/20"
# }

# variable "web_worker_sub_cidr" {
#   default = "10.30.32.0/20"
# }

variable "airs_micro_oke_worker_cidr_block" {
  default = "10.30.96.0/20"
}

variable "airs_micro_oke_pod_cidr_block" {
  default = "10.30.144.0/20"
}

variable "db_cidr_block" {
  default = "10.30.80.0/24"
}

variable "pub_api_gw_cidr_block" {
  default = "10.30.5.0/24"
}

variable "priv_lb_cidr_block" {
  default = "10.30.55.0/24"
}

# variable "web_worker_pod_cidr_block" {
#   default = "10.30.112.0/20"
# }

# variable "cms_worker_pod_cidr_block" {
#   default = "10.30.128.0/20"
# }

variable "k8s_priv_api_endpoint_cidr_block" {
  default = "10.30.60.0/24"
}

variable "nsg_lb" {
  default = "nsg-stg-lb"
}

# variable "nsg_cms" {
#   default = "nsg-stg-cms-worker"
# }

# variable "nsg_web" {
#   default = "nsg-stg-web-worker"
# }

variable "nsg_airs" {
  default = "nsg-stg-worker"
}

variable "nsg_api_gw" {
  default = "nsg-stg-api-gw"
}

variable "nsg_db" {
  default = "nsg-stg-db"
}

variable "nsg_bastion" {
  default = "nsg-stg-bastion"
}

variable "nsg_gf_host" {
  default = "nsg-stg-gfhost"
}

variable "nsg_redis" {
  default = "nsg-stg-redis"
}

variable "nsg_k8s_api_endpoint" {
  default = "nsg-stg-k8s-api-endpoint"
}
variable "nsg_airs_pod" {
  default = "nsg-stg-pod"
}

# variable "nsg_web_pod" {
#   default = "nsg-stg-web-pod"
# }

# variable "nsg_cms_pod" {
#   default = "nsg-stg-cms-pod"
# }

# variable "alert_email_1" {
#   default = "wailin.s@trinitywizards.com"
# }

# variable "alert_email_2" {
#   default = "v.wong@trinitywizards.com"
# }


variable "tenancy_ocid" {
  description = "Tenancy OCID (needed to query Availability Domains)."
  type        = string
  default     = "ocid1.tenancy.oc1..aaaaaaaatqwblz7zyqmzal6265vaijaqiwfmqejptj5zh7dhnornymkvlina"
}

# variable "ssh_public_key" {
#   description = "SSH public key content used for instance login."
#   type        = string
#   default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMNtwjmuKJ2sZgOm6hFTD0Vu2LVyR9ac72w5uyiRe8U swl@swl"
# }

variable "net_comp" {
  default = "network"
}

variable "app_comp" {
  default = "app"
}

variable "data_comp" {
  default = "data"
}

variable "mgmt_comp" {
  default = "mgmt"
}

variable "net_compartment_description" {
  default = "All subnets, Network Security Group, security list, route tables,etc"
}

variable "app_compartment_description" {
  default = "All OKE, workers nodes, Instances, etc "
}

variable "data_compartment_description" {
  default = "All Database, Redis, Block Storage, etc "
}

variable "mgmt_compartment_description" {
  default = "log analytics, log group, key vault, etc "
}

variable "service_gateway_display_name" {
  default = "prod-service-gateway"
}




###################
## Redis Cluster ##
###################

variable "redis_display_name" {
  description = "Display name for the Redis cluster."
  type        = string
  default = "stg-redis"
}

variable "software_version" {
  description = "OCI Cache engine version, for example REDIS_7_0."
  type        = string
  default     = "REDIS_7_0"
}

variable "cluster_mode" {
  description = "Cluster mode: NONSHARDED or SHARDED."
  type        = string
  default     = "NONSHARDED"

  validation {
    condition     = contains(["NONSHARDED", "SHARDED"], var.cluster_mode)
    error_message = "cluster_mode must be either NONSHARDED or SHARDED."
  }
}

variable "node_count" {
  description = "For NONSHARDED this is total nodes; for SHARDED this is nodes per shard."
  type        = number
  default     = 2
}

variable "node_memory_in_gbs" {
  description = "Memory allocated per node in GB."
  type        = number
  default     = 10
}

variable "shard_count" {
  description = "Number of shards when cluster_mode is SHARDED."
  type        = number
  default     = 3
}

variable "oci_cache_config_set_id" {
  description = "Optional OCI Cache Config Set OCID."
  type        = string
  default     = null
}

###############
##  Buckets  ##
###############

variable "bucket_name" {
  description = "Name of the Object Storage bucket."
  type        = string
  default = "stg_bucket"
}

variable "access_type" {
  description = "Bucket public access type: NoPublicAccess, ObjectRead, or ObjectReadWithoutList."
  type        = string
  default     = "ObjectRead"

  validation {
    condition     = contains(["NoPublicAccess", "ObjectRead", "ObjectReadWithoutList"], var.access_type)
    error_message = "access_type must be one of: NoPublicAccess, ObjectRead, ObjectReadWithoutList."
  }
}

variable "storage_tier" {
  description = "Bucket storage tier: Standard or Archive."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Archive"], var.storage_tier)
    error_message = "storage_tier must be either Standard or Archive."
  }
}

variable "auto_tiering" {
  description = "Auto tiering setting. Common values are Disabled or InfrequentAccess."
  type        = string
  default     = "Disabled"
}

variable "versioning" {
  description = "Enable object versioning on the bucket: Enabled or Disabled."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.versioning)
    error_message = "versioning must be either Enabled or Disabled."
  }
}

variable "object_events_enabled" {
  description = "Whether Object Storage events are enabled for the bucket."
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "Optional KMS key OCID for bucket encryption."
  type        = string
  default     = null
}

variable "metadata" {
  description = "Optional bucket metadata map."
  type        = map(string)
  default     = {}
}

variable "dr_protection_bucket_name" {
  description = "Name of the DR Protection Group Object Storage bucket."
  type        = string
  default     = "stg_dr_protection_bucket"
}

variable "dr_protection_access_type" {
  description = "DR Protection Group bucket public access type: NoPublicAccess, ObjectRead, or ObjectReadWithoutList."
  type        = string
  default     = "NoPublicAccess"

  validation {
    condition     = contains(["NoPublicAccess", "ObjectRead", "ObjectReadWithoutList"], var.dr_protection_access_type)
    error_message = "dr_protection_access_type must be one of: NoPublicAccess, ObjectRead, ObjectReadWithoutList."
  }
}

variable "dr_protection_storage_tier" {
  description = "DR Protection Group bucket storage tier: Standard or Archive."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Archive"], var.dr_protection_storage_tier)
    error_message = "dr_protection_storage_tier must be either Standard or Archive."
  }
}

variable "dr_protection_auto_tiering" {
  description = "DR Protection Group bucket auto tiering setting: Disabled or InfrequentAccess."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Disabled", "InfrequentAccess"], var.dr_protection_auto_tiering)
    error_message = "dr_protection_auto_tiering must be either Disabled or InfrequentAccess."
  }
}

variable "dr_protection_versioning" {
  description = "Enable object versioning on the DR Protection Group bucket: Enabled or Disabled."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.dr_protection_versioning)
    error_message = "dr_protection_versioning must be either Enabled or Disabled."
  }
}

variable "dr_protection_object_events_enabled" {
  description = "Whether Object Storage events are enabled for the DR Protection Group bucket."
  type        = bool
  default     = false
}

variable "dr_protection_kms_key_id" {
  description = "Optional KMS key OCID for Authentik bucket encryption."
  type        = string
  default     = null
}

## Loki Bucket variables ##

variable "loki_chucks_bucket_name" {
  description = "Name of the Loki Object Storage bucket."
  type        = string
  default     = "stg_loki_chunks_bucket"
}

variable "loki_chucks_access_type" {
  description = "loki chucks bucket public access type: NoPublicAccess, ObjectRead, or ObjectReadWithoutList."
  type        = string
  default     = "NoPublicAccess"

  validation {
    condition     = contains(["NoPublicAccess", "ObjectRead", "ObjectReadWithoutList"], var.loki_chucks_access_type)
    error_message = "loki_access_type must be one of: NoPublicAccess, ObjectRead, ObjectReadWithoutList."
  }
}

variable "loki_chucks_storage_tier" {
  description = "loki chucks bucket storage tier: Standard or Archive."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Archive"], var.loki_chucks_storage_tier)
    error_message = "loki_chucks_storage_tier must be either Standard or Archive."
  }
}

variable "loki_chucks_auto_tiering" {
  description = "loki chucks bucket auto tiering setting: Disabled or InfrequentAccess."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Disabled", "InfrequentAccess"], var.loki_chucks_auto_tiering)
    error_message = "loki_auto_tiering must be either Disabled or InfrequentAccess."
  }
}

variable "loki_chucks_versioning" {
  description = "Enable object versioning on the loki chucks bucket: Enabled or Disabled."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.loki_chucks_versioning)
    error_message = "loki_chucks_versioning must be either Enabled or Disabled."
  }
}

variable "loki_chucks_object_events_enabled" {
  description = "Whether Object Storage events are enabled for the loki chucks bucket."
  type        = bool
  default     = false
}

variable "loki_chucks_kms_key_id" {
  description = "Optional KMS key OCID for loki chucks bucket encryption."
  type        = string
  default     = null
}

variable "loki_ruler_bucket_name" {
  description = "Name of the Loki Object Storage bucket."
  type        = string
  default     = "stg_loki_ruler_bucket"
}

variable "loki_ruler_access_type" {
  description = "loki ruler bucket public access type: NoPublicAccess, ObjectRead, or ObjectReadWithoutList."
  type        = string
  default     = "NoPublicAccess"

  validation {
    condition     = contains(["NoPublicAccess", "ObjectRead", "ObjectReadWithoutList"], var.loki_ruler_access_type)
    error_message = "loki_ruler_access_type must be one of: NoPublicAccess, ObjectRead, ObjectReadWithoutList."
  }
}

variable "loki_ruler_storage_tier" {
  description = "loki ruler bucket storage tier: Standard or Archive."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Archive"], var.loki_ruler_storage_tier)
    error_message = "loki_ruler_storage_tier must be either Standard or Archive."
  }
}

variable "loki_ruler_auto_tiering" {
  description = "loki ruler bucket auto tiering setting: Disabled or InfrequentAccess."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Disabled", "InfrequentAccess"], var.loki_ruler_auto_tiering)
    error_message = "loki_ruler_auto_tiering must be either Disabled or InfrequentAccess."
  }
}

variable "loki_ruler_versioning" {
  description = "Enable object versioning on the loki ruler bucket: Enabled or Disabled."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.loki_ruler_versioning)
    error_message = "loki_ruler_versioning must be either Enabled or Disabled."
  }
}

variable "loki_ruler_object_events_enabled" {
  description = "Whether Object Storage events are enabled for the loki ruler bucket."
  type        = bool
  default     = false
}

variable "loki_ruler_kms_key_id" {
  description = "Optional KMS key OCID for loki ruler bucket encryption."
  type        = string
  default     = null
}

variable "loki_admin_bucket_name" {
  description = "Name of the Loki Object Storage bucket."
  type        = string
  default     = "stg_loki_admin_bucket"
}

variable "loki_admin_access_type" {
  description = "loki admin bucket public access type: NoPublicAccess, ObjectRead, or ObjectReadWithoutList."
  type        = string
  default     = "NoPublicAccess"

  validation {
    condition     = contains(["NoPublicAccess", "ObjectRead", "ObjectReadWithoutList"], var.loki_admin_access_type)
    error_message = "loki_admin_access_type must be one of: NoPublicAccess, ObjectRead, ObjectReadWithoutList."
  }
}

variable "loki_admin_storage_tier" {
  description = "loki admin bucket storage tier: Standard or Archive."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Archive"], var.loki_admin_storage_tier)
    error_message = "loki_admin_storage_tier must be either Standard or Archive."
  }
}

variable "loki_admin_auto_tiering" {
  description = "loki admin bucket auto tiering setting: Disabled or InfrequentAccess."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Disabled", "InfrequentAccess"], var.loki_admin_auto_tiering)
    error_message = "loki_admin_auto_tiering must be either Disabled or InfrequentAccess."
  }
}

variable "loki_admin_versioning" {
  description = "Enable object versioning on the loki admin bucket: Enabled or Disabled."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.loki_admin_versioning)
    error_message = "loki_admin_versioning must be either Enabled or Disabled."
  }
}

variable "loki_admin_object_events_enabled" {
  description = "Whether Object Storage events are enabled for the loki admin bucket."
  type        = bool
  default     = false
}

variable "loki_admin_kms_key_id" {
  description = "Optional KMS key OCID for loki chucks bucket encryption."
  type        = string
  default     = null
}

variable "tempo_bucket_name" {
  description = "Name of the Tempo Object Storage bucket."
  type        = string
  default     = "stg_tempo_bucket"
}

variable "tempo_access_type" {
  description = "tempo bucket public access type: NoPublicAccess, ObjectRead, or ObjectReadWithoutList."
  type        = string
  default     = "NoPublicAccess"

  validation {
    condition     = contains(["NoPublicAccess", "ObjectRead", "ObjectReadWithoutList"], var.tempo_access_type)
    error_message = "tempo_access_type must be one of: NoPublicAccess, ObjectRead, ObjectReadWithoutList."
  }
}

variable "tempo_storage_tier" {
  description = "tempo bucket storage tier: Standard or Archive."
  type        = string
  default     = "Standard"

  validation {
    condition     = contains(["Standard", "Archive"], var.tempo_storage_tier)
    error_message = "tempo_storage_tier must be either Standard or Archive."
  }
}

variable "tempo_auto_tiering" {
  description = "tempo bucket auto tiering setting: Disabled or InfrequentAccess."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Disabled", "InfrequentAccess"], var.tempo_auto_tiering)
    error_message = "tempo_auto_tiering must be either Disabled or InfrequentAccess."
  }
}

variable "tempo_versioning" {
  description = "Enable object versioning on the tempo bucket: Enabled or Disabled."
  type        = string
  default     = "Disabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.tempo_versioning)
    error_message = "tempo_versioning must be either Enabled or Disabled."
  }
}

variable "tempo_object_events_enabled" {
  description = "Whether Object Storage events are enabled for the tempo bucket."
  type        = bool
  default     = false
}

variable "tempo_kms_key_id" {
  description = "Optional KMS key OCID for tempo bucket encryption."
  type        = string
  default     = null
}



##############################
### Bastion host variables ###
##############################

variable "bastion_ad_index" {
  description = "Which AD index to use (0 = first AD)."
  type        = number
  default     = 0
}

variable "bastion_ssh_public_keys" {
  description = "One or more OpenSSH public keys that can log in to the bastion host. Separate keys with newlines."
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMNtwjmuKJ2sZgOm6hFTD0Vu2LVyR9ac72w5uyiRe8U swl@swl"
}

variable "bastion_image_operating_system" {
  default = "Oracle Linux"
  type    = string
}

variable "bastion_image_operating_system_version" {
  default = "9"
  type    = string
}

variable "bastion_instance_shape" {
  description = "Compute shape for the bastion host."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "bastion_availability_domain" {
  default = "kHij:AP-SINGAPORE-1-AD-1"
}

variable "bastion_shape_is_flex" {
  description = "Set to true when using a Flex shape for the bastion host."
  type        = bool
  default     = true
}

variable "bastion_image_id" {
  default = "ocid1.image.oc1.ap-singapore-1.aaaaaaaatwarx3672d5l35oyynk3vnngu6xdgbpuwez353tmmfyc4rd2a5ja"
}

variable "bastion_shape_ocpus" {
  description = "OCPUs for bastion Flex shape."
  type        = number
  default     = 1
}

variable "bastion_shape_memory_in_gbs" {
  description = "Memory in GB for bastion Flex shape."
  type        = number
  default     = 6
}

variable "bastion_boot_volume_size_in_gbs" {
  description = "Boot volume size for the bastion host."
  type        = number
  default     = 50
}

##############################
### Grafana host variables ###
##############################

variable "gfhost_ad_index" {
  description = "Which AD index to use (0 = first AD)."
  type        = number
  default     = 0
}

variable "gfhost_ssh_public_keys" {
  description = "One or more OpenSSH public keys that can log in to the Grafana host. Separate keys with newlines."
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMMNtwjmuKJ2sZgOm6hFTD0Vu2LVyR9ac72w5uyiRe8U swl@swl"
}

variable "gfhost_image_operating_system" {
  default = "Oracle Linux"
  type    = string
}

variable "gfhost_image_id" {
  default = "ocid1.image.oc1.ap-singapore-1.aaaaaaaatwarx3672d5l35oyynk3vnngu6xdgbpuwez353tmmfyc4rd2a5ja"
}

variable "gfhost_image_operating_system_version" {
  default = "9"
  type    = string
}

variable "gfhost_instance_shape" {
  description = "Compute shape for the Grafana host."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

# variable "gfhost_availability_domain" {
#   default = "aluk:AP-SINGAPORE-1-AD-1"
# }

variable "gfhost_shape_is_flex" {
  description = "Set to true when using a Flex shape for the Grafana host."
  type        = bool
  default     = true
}

variable "gfhost_shape_ocpus" {
  description = "OCPUs for Grafana Flex shape."
  type        = number
  default     = 1
}

variable "gfhost_shape_memory_in_gbs" {
  description = "Memory in GB for Grafana Flex shape."
  type        = number
  default     = 8
}

variable "gfhost_boot_volume_size_in_gbs" {
  description = "Boot volume size for the Grafana host."
  type        = number
  default     = 60
}

##############################
### AIRS OKE cluster variables  ###
##############################

#########################################
# Optional pod networking (VCN-native)  #
#########################################

variable "airs_cni_type" {
  description = "Pod networking mode. Use FLANNEL_OVERLAY for simpler networking, or OCI_VCN_IP_NATIVE if you already have pod subnets and want routable pod IPs."
  type        = string
  default     = "OCI_VCN_IP_NATIVE"

  validation {
    condition     = contains(["FLANNEL_OVERLAY", "OCI_VCN_IP_NATIVE"], var.airs_cni_type)
    error_message = "cni_type must be FLANNEL_OVERLAY or OCI_VCN_IP_NATIVE."
  }
}

variable "airs_services_cidr" {
  description = "Kubernetes services CIDR."
  type        = string
  default     = "10.96.0.0/16"
}

variable "airs_system_max_pods_per_node" {
  description = "Max pods per node for the system node pool when cni_type is OCI_VCN_IP_NATIVE."
  type        = number
  default     = 31
}


variable "airs_worker_max_pods_per_node" {
  description = "Max pods per node for the worker node pool when cni_type is OCI_VCN_IP_NATIVE."
  type        = number
  default     = 31
}

#########################
# AIRS Cluster settings  #
#########################

variable "airs_cluster_name" {
  description = "AIRS OKE cluster name."
  type        = string
  default     = "stg-cluster"
}


variable "airs_kubernetes_version" {
  description = "OKE Kubernetes version for the control plane and node pools. Pin this explicitly for production."
  type        = string
  default     = "v1.36.1"
}

variable "airs_cluster_type" {
  description = "OKE cluster type. ENHANCED_CLUSTER is recommended for production use."
  type        = string
  default     = "ENHANCED_CLUSTER"

  validation {
    condition     = contains(["BASIC_CLUSTER", "ENHANCED_CLUSTER"], var.airs_cluster_type)
    error_message = "cluster_type must be BASIC_CLUSTER or ENHANCED_CLUSTER."
  }
}

##################################
# AIRS SSH / node instance extras #
##################################

variable "stg_oke_ssh_public_key" {
  description = "SSH public key injected into OKE worker nodes."
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDjNRHetQJYNR93uEaiNe9j+DXfT3ssapYp/npJ74AqDxbTzt2aky8ofRMU1OFgrZQglCywL0T1qY1x2oYFVp3BLJUOKMaWP28jQlX2L9KDqD8kziKgq0ydVW7RkevApAGeVflD6jv2LF34+S9zlgjRezq+UzE1zAaFPWdZRaHOfbMhb86uxBpFU+I2SmRni9qYpzQAMcoTmGA0crVN2mhdP/9ZxRr+BllVCXeiSnmoXHlaNujUY6qGzzjew29W7bNi3OLjtiCVy6O+H6+HQP4Xhn83CYVZZTdHjpm28fu1yz2XmnhmEs8XG9fsU8vR/hv3u0psmB1rIS2EAhA0+VmukNSkP2yVIBcwhYgS5jsZEoTeKUXF+eld+mV88vpRFfEJ3Koog/Vvc47mfJ5l6F0yiPIDGWS2Sv/MhzRVxIaDpWHjgOxQEysq6sQ7hwUrO1uDkLvUXFx7Ru97Eaz6RMhPLd1yHBbq4inRTXLEfCYaPdGbReU9CvAXlruycfw556E= wailin_s@a6b3bc12eb0b"
}

#########################
# AIRS System node pool  #
#########################

variable "airs_system_node_pool_name" {
  description = "Name of the system node pool."
  type        = string
  default     = "stg-system-pool"
}

variable "airs_system_node_count" {
  description = "Desired number of nodes in the system node pool."
  type        = number
  default     = 1
}

variable "airs_system_node_shape" {
  description = "Compute shape for the system node pool."
  type        = string
  default     = "VM.Standard.E5.Flex"
}

variable "airs_system_memory_in_gbs" {
  default = 16
}

variable "airs_system_ocpus" {
  default = 1
}

variable "airs_system_availability_domain" {
  default = "aluk:AP-SINGAPORE-1-AD-1"
}

variable "airs_system_node_image_id" {
  default = "ocid1.image.oc1.ap-singapore-1.aaaaaaaazhczlmpeuyd23hlyebaf5qoxmlmi7ugc2uyw2zkdmhr5rwgocaga"
}

#########################
# AIRS Worker node pool  #
#########################

variable "airs_worker_node_image_id" {
  default = "ocid1.image.oc1.ap-singapore-1.aaaaaaaazhczlmpeuyd23hlyebaf5qoxmlmi7ugc2uyw2zkdmhr5rwgocaga"
}

variable "airs_worker_node_pool_name" {
  description = "Name of the worker node pool."
  type        = string
  default     = "stg-worker-pool"
}

variable "airs_worker_node_count" {
  description = "Desired number of nodes in the worker node pool."
  type        = number
  default     = 2
}

variable "airs_worker_availability_domain" {
  default = "aluk:AP-SINGAPORE-1-AD-1"
}

variable "airs_worker_node_shape" {
  description = "Compute shape for the worker node pool."
  type        = string
  default     = "VM.Standard.E5.Flex"
}

variable "airs_worker_memory_in_gbs" {
  default = "16"
}

variable "airs_worker_ocpus" {
  default = "1"
}

variable "airs_worker_node_min_count" {
  type    = number
  default = 2
}

variable "airs_worker_node_max_count" {
  type    = number
  default = 30
}

variable "airs_cluster_autoscaler_num_replicas" {
  type    = number
  default = 2
}

variable "airs_cluster_autoscaler_max_node_provision_time" {
  type    = string
  default = "25m"
}

# Usually instance principal is the simplest for OKE CA add-on.
variable "airs_cluster_autoscaler_auth_type" {
  type    = string
  default = "instance"
}

variable "airs_cluster_autoscaler_scale_down_delay_after_add" {
  type    = string
  default = "10m"
  description = "How long after scale up that scale down evaluation resumes."
}

variable "airs_cluster_autoscaler_scale_down_unneeded_time" {
  type    = string
  default = "10m"
}

variable "airs_cordonNodeBeforeTerminating" {
  type = bool
  default = true
  description = "cordon nodes before terminating during downscale process"
}

################################
# AIRS Rolling update behaviors #
################################

variable "airs_node_eviction_grace_duration" {
  description = "Drain grace duration used by OKE during node actions such as cycling or replacement."
  type        = string
  default     = "PT1H"
}

variable "airs_node_force_action_after_grace_duration" {
  description = "Whether OKE should continue node actions if pods cannot be fully evicted before the grace duration."
  type        = bool
  default     = false
}

variable "airs_node_force_delete_after_grace_duration" {
  description = "Whether the underlying compute instance should be deleted if eviction cannot complete in time."
  type        = bool
  default     = false
}

variable "airs_node_cycling_enabled" {
  description = "Enable node cycling for safer rolling replacement/updates."
  type        = bool
  default     = false
}

variable "airs_node_cycling_maximum_surge" {
  description = "Maximum additional new compute instances temporarily created during cycling. Supports integer or percentage."
  type        = string
  default     = "25%"
}

variable "airs_node_cycling_maximum_unavailable" {
  description = "Maximum active nodes that can be unavailable during cycling. Supports integer or percentage."
  type        = string
  default     = "0"
}

variable "defined_tags" {
  description = "Defined tags to apply to the cluster and node pools."
  type        = map(string)
  default     = {}
}

variable "airs_metrics_server_num_replicas" {
  description = "Number of replicas for OKE Kubernetes Metrics Server add-on."
  type        = number
  default     = 1
}

variable "airs_cert_manager_num_replicas" {
  description = "Number of replicas for OKE Cert Manager add-on."
  type        = number
  default     = 1
}



# #####################
# # WEB Cluster settings  #
# #####################

# variable "web_cluster_name" {
#   description = "OKE cluster name."
#   type        = string
#   default     = "stg-web-cluster"
# }


# variable "web_kubernetes_version" {
#   description = "OKE Kubernetes version for the control plane and node pools. Pin this explicitly for production."
#   type        = string
#   default     = "v1.35.0"
# }

# variable "web_cluster_type" {
#   description = "OKE cluster type. ENHANCED_CLUSTER is recommended for production use."
#   type        = string
#   default     = "ENHANCED_CLUSTER"

#   validation {
#     condition     = contains(["BASIC_CLUSTER", "ENHANCED_CLUSTER"], var.web_cluster_type)
#     error_message = "cluster_type must be BASIC_CLUSTER or ENHANCED_CLUSTER."
#   }
# }

# variable "web_cni_type" {
#   description = "Pod networking mode. Use FLANNEL_OVERLAY for simpler networking, or OCI_VCN_IP_NATIVE if you already have pod subnets and want routable pod IPs."
#   type        = string
#   default     = "OCI_VCN_IP_NATIVE"

#   validation {
#     condition     = contains(["FLANNEL_OVERLAY", "OCI_VCN_IP_NATIVE"], var.web_cni_type)
#     error_message = "cni_type must be FLANNEL_OVERLAY or OCI_VCN_IP_NATIVE."
#   }
# }


# variable "web_services_cidr" {
#   description = "Kubernetes services CIDR."
#   type        = string
#   default     = "10.96.0.0/16"
# }

# variable "web_system_max_pods_per_node" {
#   description = "Max pods per node for the system node pool when cni_type is OCI_VCN_IP_NATIVE."
#   type        = number
#   default     = 31
# }


# variable "web_worker_max_pods_per_node" {
#   description = "Max pods per node for the worker node pool when cni_type is OCI_VCN_IP_NATIVE."
#   type        = number
#   default     = 31
# }

# ##############################
# # SSH / node instance extras #
# ##############################

# variable "web_oke_ssh_public_key" {
#   description = "SSH public key injected into OKE worker nodes."
#   type        = string
#   default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDjNRHetQJYNR93uEaiNe9j+DXfT3ssapYp/npJ74AqDxbTzt2aky8ofRMU1OFgrZQglCywL0T1qY1x2oYFVp3BLJUOKMaWP28jQlX2L9KDqD8kziKgq0ydVW7RkevApAGeVflD6jv2LF34+S9zlgjRezq+UzE1zAaFPWdZRaHOfbMhb86uxBpFU+I2SmRni9qYpzQAMcoTmGA0crVN2mhdP/9ZxRr+BllVCXeiSnmoXHlaNujUY6qGzzjew29W7bNi3OLjtiCVy6O+H6+HQP4Xhn83CYVZZTdHjpm28fu1yz2XmnhmEs8XG9fsU8vR/hv3u0psmB1rIS2EAhA0+VmukNSkP2yVIBcwhYgS5jsZEoTeKUXF+eld+mV88vpRFfEJ3Koog/Vvc47mfJ5l6F0yiPIDGWS2Sv/MhzRVxIaDpWHjgOxQEysq6sQ7hwUrO1uDkLvUXFx7Ru97Eaz6RMhPLd1yHBbq4inRTXLEfCYaPdGbReU9CvAXlruycfw556E= wailin_s@a6b3bc12eb0b"
# }

# #####################
# # System node pool  #
# #####################

# variable "web_system_node_pool_name" {
#   description = "Name of the system node pool."
#   type        = string
#   default     = "stg-system-pool"
# }

# variable "web_system_node_count" {
#   description = "Desired number of nodes in the system node pool."
#   type        = number
#   default     = 1
# }

# variable "web_system_node_shape" {
#   description = "Compute shape for the system node pool."
#   type        = string
#   default     = "VM.Standard.E5.Flex"
# }

# variable "web_system_memory_in_gbs" {
#   default = 16
# }

# variable "web_system_ocpus" {
#   default = 1
# }


# variable "web_system_availability_domain" {
#   default = "aluk:AP-SINGAPORE-1-AD-1"
# }

# #####################
# # Worker node pool  #
# #####################

# variable "web_worker_node_pool_name" {
#   description = "Name of the worker node pool."
#   type        = string
#   default     = "stg-worker-pool"
# }

# variable "web_worker_node_count" {
#   description = "Desired number of nodes in the worker node pool."
#   type        = number
#   default     = 1
# }

# variable "web_worker_availability_domain" {
#   default = "aluk:AP-SINGAPORE-1-AD-1"
# }

# variable "web_worker_node_shape" {
#   description = "Compute shape for the worker node pool."
#   type        = string
#   default     = "VM.Standard.E5.Flex"
# }

# variable "web_worker_memory_in_gbs" {
#   default = "16"
# }

# variable "web_worker_ocpus" {
#   default = "1"
# }

# #########################################
# # OKE Worker Autoscaler variables
# #########################################
# variable "web_enable_cluster_autoscaler" {
#   type    = bool
#   default = true
# }

# variable "web_worker_node_min_count" {
#   type    = number
#   default = 1
# }

# variable "web_worker_node_max_count" {
#   type    = number
#   default = 150
# }

# variable "web_cluster_autoscaler_num_replicas" {
#   type    = number
#   default = 2
# }

# variable "web_cluster_autoscaler_max_node_provision_time" {
#   type    = string
#   default = "25m"
# }

# # Usually instance principal is the simplest for OKE CA add-on.
# variable "web_cluster_autoscaler_auth_type" {
#   type    = string
#   default = "instance"
# }

# variable "web_cluster_autoscaler_scale_down_delay_after_add" {
#   type    = string
#   default = "10m"
#   description = "How long after scale up that scale down evaluation resumes."
# }

# variable "web_cluster_autoscaler_scale_down_unneeded_time" {
#   type    = string
#   default = "10m"
# }

# variable "web_cluster_autoscaler_scale_down_utilization_threshold" {
#   type    = string
#   default = "0.4"
# }

# # variable "cluster_autoscaler_max_graceful_termination_sec" {
# #   type    = string
# #   default = "120"
# # }

# variable "web_cordonNodeBeforeTerminating" {
#   type = bool
#   default = true
#   description = "cordon nodes before terminating during downscale process"
# }


# ############################
# # Rolling update behaviors #
# ############################

# variable "web_node_eviction_grace_duration" {
#   description = "Drain grace duration used by OKE during node actions such as cycling or replacement."
#   type        = string
#   default     = "PT60M"
# }

# variable "web_node_force_action_after_grace_duration" {
#   description = "Whether OKE should continue node actions if pods cannot be fully evicted before the grace duration."
#   type        = bool
#   default     = false
# }

# variable "web_node_force_delete_after_grace_duration" {
#   description = "Whether the underlying compute instance should be deleted if eviction cannot complete in time."
#   type        = bool
#   default     = false
# }

# variable "web_node_cycling_enabled" {
#   description = "Enable node cycling for safer rolling replacement/updates."
#   type        = bool
#   default     = false
# }

# variable "web_node_cycling_maximum_surge" {
#   description = "Maximum additional new compute instances temporarily created during cycling. Supports integer or percentage."
#   type        = string
#   default     = "25%"
# }

# variable "web_node_cycling_maximum_unavailable" {
#   description = "Maximum active nodes that can be unavailable during cycling. Supports integer or percentage."
#   type        = string
#   default     = "0"
# }

# ################
# # Tagging      #
# ################




# ##############################
# ### CMS OKE cluster variables  ###
# ##############################

# #########################################
# # Optional pod networking (VCN-native)  #
# #########################################

# variable "cms_cni_type" {
#   description = "Pod networking mode. Use FLANNEL_OVERLAY for simpler networking, or OCI_VCN_IP_NATIVE if you already have pod subnets and want routable pod IPs."
#   type        = string
#   default     = "OCI_VCN_IP_NATIVE"

#   validation {
#     condition     = contains(["FLANNEL_OVERLAY", "OCI_VCN_IP_NATIVE"], var.cms_cni_type)
#     error_message = "cni_type must be FLANNEL_OVERLAY or OCI_VCN_IP_NATIVE."
#   }
# }



# variable "cms_services_cidr" {
#   description = "Kubernetes services CIDR."
#   type        = string
#   default     = "10.96.0.0/16"
# }

# variable "cms_system_max_pods_per_node" {
#   description = "Max pods per node for the system node pool when cni_type is OCI_VCN_IP_NATIVE."
#   type        = number
#   default     = 31
# }


# variable "cms_worker_max_pods_per_node" {
#   description = "Max pods per node for the worker node pool when cni_type is OCI_VCN_IP_NATIVE."
#   type        = number
#   default     = 31
# }

# #########################
# # CMS Cluster settings  #
# #########################

# variable "cms_cluster_name" {
#   description = "CMS OKE cluster name."
#   type        = string
#   default     = "stg-cms-cluster"
# }


# variable "cms_kubernetes_version" {
#   description = "OKE Kubernetes version for the control plane and node pools. Pin this explicitly for production."
#   type        = string
#   default     = "v1.35.0"
# }

# variable "cms_cluster_type" {
#   description = "OKE cluster type. ENHANCED_CLUSTER is recommended for production use."
#   type        = string
#   default     = "ENHANCED_CLUSTER"

#   validation {
#     condition     = contains(["BASIC_CLUSTER", "ENHANCED_CLUSTER"], var.cms_cluster_type)
#     error_message = "cluster_type must be BASIC_CLUSTER or ENHANCED_CLUSTER."
#   }
# }



# ##################################
# # CMS SSH / node instance extras #
# ##################################

# variable "cms_oke_ssh_public_key" {
#   description = "SSH public key injected into OKE worker nodes."
#   type        = string
#   default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDjNRHetQJYNR93uEaiNe9j+DXfT3ssapYp/npJ74AqDxbTzt2aky8ofRMU1OFgrZQglCywL0T1qY1x2oYFVp3BLJUOKMaWP28jQlX2L9KDqD8kziKgq0ydVW7RkevApAGeVflD6jv2LF34+S9zlgjRezq+UzE1zAaFPWdZRaHOfbMhb86uxBpFU+I2SmRni9qYpzQAMcoTmGA0crVN2mhdP/9ZxRr+BllVCXeiSnmoXHlaNujUY6qGzzjew29W7bNi3OLjtiCVy6O+H6+HQP4Xhn83CYVZZTdHjpm28fu1yz2XmnhmEs8XG9fsU8vR/hv3u0psmB1rIS2EAhA0+VmukNSkP2yVIBcwhYgS5jsZEoTeKUXF+eld+mV88vpRFfEJ3Koog/Vvc47mfJ5l6F0yiPIDGWS2Sv/MhzRVxIaDpWHjgOxQEysq6sQ7hwUrO1uDkLvUXFx7Ru97Eaz6RMhPLd1yHBbq4inRTXLEfCYaPdGbReU9CvAXlruycfw556E= wailin_s@a6b3bc12eb0b"
# }

# #########################
# # CMS System node pool  #
# #########################

# variable "cms_system_node_pool_name" {
#   description = "Name of the system node pool."
#   type        = string
#   default     = "stg-system-pool"
# }

# variable "cms_system_node_count" {
#   description = "Desired number of nodes in the system node pool."
#   type        = number
#   default     = 1
# }

# variable "cms_system_node_shape" {
#   description = "Compute shape for the system node pool."
#   type        = string
#   default     = "VM.Standard.E5.Flex"
# }

# variable "cms_system_memory_in_gbs" {
#   default = 16
# }

# variable "cms_system_ocpus" {
#   default = 1
# }

# variable "cms_system_availability_domain" {
#   default = "aluk:AP-SINGAPORE-1-AD-1"
# }

# #########################
# # CMS Worker node pool  #
# #########################

# variable "cms_worker_node_pool_name" {
#   description = "Name of the worker node pool."
#   type        = string
#   default     = "stg-worker-pool"
# }

# variable "cms_worker_node_count" {
#   description = "Desired number of nodes in the worker node pool."
#   type        = number
#   default     = 3
# }

# variable "cms_worker_availability_domain" {
#   default = "aluk:AP-SINGAPORE-1-AD-1"
# }

# variable "cms_worker_node_shape" {
#   description = "Compute shape for the worker node pool."
#   type        = string
#   default     = "VM.Standard.E5.Flex"
# }

# variable "cms_worker_memory_in_gbs" {
#   default = "16"
# }

# variable "cms_worker_ocpus" {
#   default = "1"
# }

# #########################################
# # CMS OKE Worker Autoscaler variables  ##
# #########################################
# # variable "cms_enable_cluster_autoscaler" {
# #   type    = bool
# #   default = true
# # }

# variable "cms_worker_node_min_count" {
#   type    = number
#   default = 3
# }

# variable "cms_worker_node_max_count" {
#   type    = number
#   default = 25
# }

# variable "cms_cluster_autoscaler_num_replicas" {
#   type    = number
#   default = 2
# }

# variable "cms_cluster_autoscaler_max_node_provision_time" {
#   type    = string
#   default = "25m"
# }

# # Usually instance principal is the simplest for OKE CA add-on.
# variable "cms_cluster_autoscaler_auth_type" {
#   type    = string
#   default = "instance"
# }

# variable "cms_cluster_autoscaler_scale_down_delay_after_add" {
#   type    = string
#   default = "10m"
#   description = "How long after scale up that scale down evaluation resumes."
# }

# variable "cms_cluster_autoscaler_scale_down_unneeded_time" {
#   type    = string
#   default = "10m"
# }

# variable "cms_cordonNodeBeforeTerminating" {
#   type = bool
#   default = true
#   description = "cordon nodes before terminating during downscale process"
# }


# ################################
# # CMS Rolling update behaviors #
# ################################

# variable "cms_node_eviction_grace_duration" {
#   description = "Drain grace duration used by OKE during node actions such as cycling or replacement."
#   type        = string
#   default     = "PT60M"
# }

# variable "cms_node_force_action_after_grace_duration" {
#   description = "Whether OKE should continue node actions if pods cannot be fully evicted before the grace duration."
#   type        = bool
#   default     = false
# }

# variable "cms_node_force_delete_after_grace_duration" {
#   description = "Whether the underlying compute instance should be deleted if eviction cannot complete in time."
#   type        = bool
#   default     = false
# }

# variable "cms_node_cycling_enabled" {
#   description = "Enable node cycling for safer rolling replacement/updates."
#   type        = bool
#   default     = false
# }

# variable "cms_node_cycling_maximum_surge" {
#   description = "Maximum additional new compute instances temporarily created during cycling. Supports integer or percentage."
#   type        = string
#   default     = "25%"
# }

# variable "cms_node_cycling_maximum_unavailable" {
#   description = "Maximum active nodes that can be unavailable during cycling. Supports integer or percentage."
#   type        = string
#   default     = "0"
# }

# ###############
# ###  Vault  ###
# ###############


# variable "vault_name" {
#   description = "Display name of the OCI KMS vault."
#   type        = string
#   default = "prod_vault"
# }

# variable "vault_type" {
#   description = "Vault type to create. DEFAULT is the standard OCI vault type."
#   type        = string
#   default     = "DEFAULT"
# }

# variable "secret_name" {
#   description = "Name of the secret."
#   type        = string
#   default = "db_cred"
# }

# variable "vault_rotation_interval_in_days" {
#   default = 60
#   type = string
# }

# variable "key_protection_mode" {
#   default = "HSM"
#   type = string
#   description = "HSM is default"
# }

# variable "secret_value" {
#   description = "Plaintext secret value. It will be base64 encoded before being sent to OCI."
#   type        = map(string)
#   sensitive   = false
#   default = {
#     password = "pa55w0rd"
#   }
# }

# variable "secret_version_name" {
#   description = "Optional name for the secret version."
#   type        = string
#   default     = null
# }

# variable "secret_stage" {
#   description = "Optional stage for the secret version, such as CURRENT or PENDING."
#   type        = string
#   default     = null
# }

# variable "rotation_interval_in_days" {
#   default = 7
#   description = "Key Rotation Day"
#   type = number
# }

# variable "time_of_schedule_start" {
#   default = "2026-03-20T00:00:00Z"
#   description = "Key Rotation Start Schedule"
# }

#######################
###     NPA         ###
#######################
variable "npa_display_name" {
  description = "Friendly name for the Path Analyzer Test."
  type        = string
  default     = "stg-subnet-connectivity-test"
}

variable "protocol" {
  description = "IP protocol to use for the test. Common values: TCP, UDP, ICMP."
  type        = string
  default     = "TCP"

  validation {
    condition     = contains(["TCP", "UDP", "ICMP"], var.protocol)
    error_message = "protocol must be one of: TCP, UDP, ICMP."
  }
}
variable "airs_source_ip" {
  description = "Source IPv4 address inside the source subnet CIDR. It does not need to be active."
  type        = string
  default     = "10.30.96.10"
}

variable "airs_pod_source_ip" {
  description = "Source IPv4 address inside the source subnet CIDR. It does not need to be active."
  type        = string
  default     = "10.30.144.10"
}


variable "db_destination_ip" {
  description = "Destination IPv4 address inside the destination subnet CIDR. It does not need to be active."
  type        = string
  default     = "10.30.80.30"
}

variable "redis_destination_ip" {
  description = "Destination IPv4 address inside the destination subnet CIDR. It does not need to be active."
  type        = string
  default     = "10.30.80.40"
}

variable "db_destination_port" {
  description = "Destination port for TCP/UDP analysis."
  type        = number
  default     = 5432
}

variable "redis_destination_port" {
  description = "Destination port for TCP/UDP analysis."
  type        = number
  default     = 6379
}
variable "source_port" {
  description = "Optional source port for TCP/UDP analysis."
  type        = number
  default     = 1024
}

variable "is_bi_directional_analysis" {
  description = "Whether to check both forward and reverse paths."
  type        = bool
  default     = true
}

# variable "cms_source_ip" {
#   description = "Source IPv4 address inside the source subnet CIDR. It does not need to be active."
#   type        = string
#   default     = "10.30.16.10"
# }

# variable "cms_pod_source_ip" {
#   description = "Source IPv4 address inside the source subnet CIDR. It does not need to be active."
#   type        = string
#   default     = "10.30.128.10"
# }

# variable "cms_destination_ip" {
#   description = "Source IPv4 address inside the source subnet CIDR. It does not need to be active."
#   type        = string
#   default     = "10.30.16.10"
# }

# variable "cms_pod_destination_ip" {
#   description = "Source IPv4 address inside the source subnet CIDR. It does not need to be active."
#   type        = string
#   default     = "10.30.128.10"
# }

# variable "web_source_ip" {
#   description = "Source IPv4 address inside the source subnet CIDR. It does not need to be active."
#   type        = string
#   default     = "10.30.32.10"
# }

# variable "web_pod_source_ip" {
#   description = "Source IPv4 address inside the source subnet CIDR. It does not need to be active."
#   type        = string
#   default     = "10.30.112.10"
# }

# variable "web_destination_ip" {
#   description = "Source IPv4 address inside the source subnet CIDR. It does not need to be active."
#   type        = string
#   default     = "10.30.32.10"
# }

# variable "web_pod_destination_ip" {
#   description = "Source IPv4 address inside the source subnet CIDR. It does not need to be active."
#   type        = string
#   default     = "10.30.112.10"
# }



# variable "cms_destination_port" {
#   description = "Destination port for TCP/UDP analysis."
#   type        = number
#   default     = 80
# }

# variable "web_destination_port" {
#   description = "Destination port for TCP/UDP analysis."
#   type        = number
#   default     = 80
# }



# ##################################
# ## Database Variable           ###
# ##################################

# variable "db_display_name" {
#   type        = string
#   description = "Display name for the PostgreSQL DB system"
#   default     = "oci-postgresql-db"
# }

# variable "description" {
#   type        = string
#   description = "Description for the PostgreSQL DB system"
#   default     = "Managed PostgreSQL DB system created by Terraform"
# }

# variable "db_version" {
#   type        = number
#   description = "PostgreSQL major version"
#   default     = 16
# }

# variable "pg_db_shape" {
#   type        = string
#   description = "Shape for OCI PostgreSQL DB system"
#   default     = "PostgreSQL.VM.Standard.E5.Flex"
# }

# variable "pg_db_instance_count" {
#   type        = number
#   description = "Number of DB instances/nodes"
#   default     = 1
# }

# variable "pg_db_instance_ocpu_count" {
#   type        = number
#   description = "OCPU count per DB instance"
#   default     = 1
# }

# variable "pg_db_instance_memory_size_in_gbs" {
#   type        = number
#   description = "Memory per DB instance in GB"
#   default     = 16
# }

# variable "admin_username" {
#   type        = string
#   description = "PostgreSQL admin username"
#   default     = "admin"
# }

# variable "admin_password" {
#   type        = string
#   description = "PostgreSQL admin password"
#   default = "153709admin$%"
#   # sensitive   = true  
# }

# variable "pg_db_enable_reader_endpoint" {
#   type        = bool
#   description = "Enable reader endpoint"
#   default     = false
# }

# variable "pg_db_storage_is_regionally_durable" {
#   type        = bool
#   description = "Use regionally durable storage"
#   default     = false
# }

# variable "pg_db_storage_system_type" {
#   type        = string
#   description = "Storage system type"
#   default     = "OCI_OPTIMIZED_STORAGE"
# }

# variable "pg_db_availability_domain" {
#   type        = string
#   description = "Required only when storage_is_regionally_durable = false"
#   default     = "aluk:AP-SINGAPORE-1-AD-1" ## null
# }


# ##################################
# ### Loadbalancer Variable      ###
# ##################################

# variable "lb_display_name" {
#   type    = string
#   default = "pub-lb"
# }

# variable "is_private" {
#   type    = bool
#   default = false
# }

# variable "lb_shape" {
#   description = "flexible or traditional shapes"
#   type        = string
#   default     = "flexible"
# }

# variable "min_bandwidth" {
#   type    = number
#   default = 10
# }

# variable "max_bandwidth" {
#   type    = number
#   default = 100
# }

# variable "backendset_name" {
#   type    = string
#   default = "backendset1"
# }

# variable "listener_name" {
#   type    = string
#   default = "listener1"
# }

# variable "listener_port" {
#   type    = number
#   default = 80
# }

# variable "backend_port" {
#   type    = number
#   default = 80
# }

# variable "backend_ips" {
#   description = "Map of backend IPs"
#   type        = map(string)
#   default     = {}
# }

# variable "healthcheck_port" {
#   type    = number
#   default = 80
# }




