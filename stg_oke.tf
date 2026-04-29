#########################################
# Resource: AIRS OKE cluster
# Creates an ENHANCED or BASIC OKE cluster with a PRIVATE API endpoint.
#########################################
resource "oci_containerengine_cluster" "stg_oke" {
  compartment_id     = oci_identity_compartment.app_compartment.id
  name               = var.airs_cluster_name
  kubernetes_version = var.airs_kubernetes_version
  vcn_id             = oci_core_vcn.terra_vcn.id
  type               = var.airs_cluster_type

  freeform_tags = var.freeform_tags

  # Private Kubernetes API endpoint
  endpoint_config {
    subnet_id            = oci_core_subnet.prod_k8s_priv_api_endpoint_sub.id
    nsg_ids              = [oci_core_network_security_group.nsg_prod_k8s_api_endpoints.id]
    is_public_ip_enabled = false
  }

  # Cluster-wide pod networking mode
  cluster_pod_network_options {
    cni_type = var.airs_cni_type
  }

  # Core cluster options
  options {
    ip_families = ["IPv4"]

    kubernetes_network_config {
      pods_cidr     = oci_core_subnet.airs_micro_oke_worker_sub.cidr_block
      services_cidr = var.airs_services_cidr
    }

    add_ons {
      is_kubernetes_dashboard_enabled = true
      is_tiller_enabled               = false
    }

    service_lb_subnet_ids = [oci_core_subnet.lb_subnet.id]

    service_lb_config {
      freeform_tags = merge(var.freeform_tags, {
        "oke-resource-type" = "service-lb"
      })
      defined_tags = var.defined_tags
    }

    persistent_volume_config {
      freeform_tags = merge(var.freeform_tags, {
        "oke-resource-type" = "persistent-volume"
      })
      defined_tags = var.defined_tags
    }
  }

  timeouts {
    create = "2h"
    update = "2h"
    delete = "2h"
  }
}

#########################################
# Data source: AIRS OKE node pool options
# Supported shapes, k8s versions, and image sources for node pools.
# Use "all" so Terraform can evaluate at plan time.
#########################################
data "oci_containerengine_node_pool_option" "airs_all_options" {
  node_pool_option_id = "all"
  compartment_id      = oci_identity_compartment.app_compartment.id
}

#########################################
# Locals: image selection for system + worker
#########################################
locals {
  airs_system_k8s_version = replace(var.airs_kubernetes_version, "v", "")
  airs_worker_k8s_version = replace(var.airs_kubernetes_version, "v", "")

  # -----------------------------
  # SYSTEM image selection
  # -----------------------------
  # Pick OKE Oracle Linux images matching the requested k8s version.
  # Exclude Arm and GPU images.
  airs_system_candidate_source_map = {
    for s in data.oci_containerengine_node_pool_option.airs_all_options.sources :
    s.source_name => s
    if s.source_type == "IMAGE"
      && can(regex("^Oracle-Linux", s.source_name))
      && can(regex("-OKE-${local.airs_system_k8s_version}-", s.source_name))
      && !can(regex("aarch64", lower(s.source_name)))
      && !can(regex("gpu", lower(s.source_name)))
  }

  airs_system_candidate_source_names = reverse(sort(keys(local.airs_system_candidate_source_map)))

  airs_system_node_image_id = (
    length(local.airs_system_candidate_source_names) > 0
    ? local.airs_system_candidate_source_map[local.airs_system_candidate_source_names[0]].image_id
    : null
  )

  # -----------------------------
  # WORKER image selection
  # -----------------------------
  airs_worker_candidate_source_map = {
    for s in data.oci_containerengine_node_pool_option.airs_all_options.sources :
    s.source_name => s
    if s.source_type == "IMAGE"
      && can(regex("^Oracle-Linux", s.source_name))
      && can(regex("-OKE-${local.airs_worker_k8s_version}-", s.source_name))
      && !can(regex("aarch64", lower(s.source_name)))
      && !can(regex("gpu", lower(s.source_name)))
  }

  airs_worker_candidate_source_names = reverse(sort(keys(local.airs_worker_candidate_source_map)))

  airs_worker_node_image_id = (
    length(local.airs_worker_candidate_source_names) > 0
    ? local.airs_worker_candidate_source_map[local.airs_worker_candidate_source_names[0]].image_id
    : null
  )
}

#########################################
# Resource: system node pool
# Intended for platform/system workloads.
#########################################
resource "oci_containerengine_node_pool" "airs_system" {
  cluster_id         = oci_containerengine_cluster.stg_oke.id
  compartment_id     = oci_identity_compartment.app_compartment.id
  name               = var.airs_system_node_pool_name
  kubernetes_version = var.airs_kubernetes_version

  node_shape = var.airs_system_node_shape

  freeform_tags = merge(var.freeform_tags, {
    "oke-nodepool-role" = "system"
  })
  defined_tags = var.defined_tags

  initial_node_labels {
    key = "name"
    value = "abdigital-stg-pool-system"
  }
  initial_node_labels {
    key = "nodepool-role"
    value = "system"
  }


  # Rolling replacement / safer maintenance behavior.
  node_eviction_node_pool_settings {
    eviction_grace_duration              = var.airs_node_eviction_grace_duration
    is_force_action_after_grace_duration = var.airs_node_force_action_after_grace_duration
    is_force_delete_after_grace_duration = var.airs_node_force_delete_after_grace_duration
  }

  node_pool_cycling_details {
    is_node_cycling_enabled = var.airs_node_cycling_enabled
    maximum_surge           = var.airs_node_cycling_maximum_surge
    maximum_unavailable     = var.airs_node_cycling_maximum_unavailable
  }

  node_source_details {
    image_id    = local.airs_system_node_image_id
    source_type = "IMAGE"
  }

  node_shape_config {
    memory_in_gbs = var.airs_system_memory_in_gbs
    ocpus         = var.airs_system_ocpus
  }

  # Node placement and network configuration.
  node_config_details {
    size = var.airs_system_node_count

    placement_configs {
      availability_domain = var.airs_system_availability_domain
      subnet_id           = oci_core_subnet.airs_micro_oke_worker_sub.id
    }

    nsg_ids = [oci_core_network_security_group.nsg_prod_airs.id]

    node_pool_pod_network_option_details {
      cni_type          = var.airs_cni_type
      max_pods_per_node = var.airs_system_max_pods_per_node
      pod_subnet_ids    = [oci_core_subnet.airs_micro_oke_pod_sub.id]
      pod_nsg_ids       = [oci_core_network_security_group.nsg_prod_airs_pod.id]
    }
  }


  ssh_public_key = var.stg_oke_ssh_public_key

  lifecycle {
    precondition {
      condition     = contains(data.oci_containerengine_node_pool_option.airs_all_options.shapes, var.airs_system_node_shape)
      error_message = "The requested system_node_shape is not listed as a supported OKE node-pool shape in this tenancy/region."
    }

    precondition {
      condition     = local.airs_system_node_image_id != null
      error_message = "No compatible OKE image was found in node-pool-options for the requested Kubernetes version."
    }
  }
}

#########################################
# Resource: worker node pool
# Intended for platform/worker workloads.
#########################################
resource "oci_containerengine_node_pool" "airs_worker" {
  cluster_id         = oci_containerengine_cluster.stg_oke.id
  compartment_id     = oci_identity_compartment.app_compartment.id
  name               = var.airs_worker_node_pool_name
  kubernetes_version = var.airs_kubernetes_version

  node_shape = var.airs_worker_node_shape

  freeform_tags = merge(var.freeform_tags, {
    "oke-nodepool-role" = "worker"
  })
  defined_tags = var.defined_tags

  initial_node_labels {
    key = "name"
    value = "abdigital-stg-pool-app"
  }

  # Rolling replacement / safer maintenance behavior.
  node_eviction_node_pool_settings {
    eviction_grace_duration              = var.airs_node_eviction_grace_duration
    is_force_action_after_grace_duration = var.airs_node_force_action_after_grace_duration
    is_force_delete_after_grace_duration = var.airs_node_force_delete_after_grace_duration
  }

  node_pool_cycling_details {
    is_node_cycling_enabled = var.airs_node_cycling_enabled
    maximum_surge           = var.airs_node_cycling_maximum_surge
    maximum_unavailable     = var.airs_node_cycling_maximum_unavailable
  }

  node_source_details {
    image_id    = local.airs_worker_node_image_id
    source_type = "IMAGE"
  }

  node_shape_config {
    memory_in_gbs = var.airs_worker_memory_in_gbs
    ocpus         = var.airs_worker_ocpus
  }

  # Node placement and network configuration.
  node_config_details {
    # This is only the INITIAL size.
    # After the autoscaler starts, it can move between min/max.

    size = var.airs_worker_node_count

    placement_configs {
      availability_domain = var.airs_worker_availability_domain
      subnet_id           = oci_core_subnet.airs_micro_oke_worker_sub.id
    }

    nsg_ids = [oci_core_network_security_group.nsg_prod_airs.id]

    node_pool_pod_network_option_details {
      cni_type          = var.airs_cni_type
      max_pods_per_node = var.airs_worker_max_pods_per_node
      pod_subnet_ids    = [oci_core_subnet.airs_micro_oke_pod_sub.id]
      pod_nsg_ids       = [oci_core_network_security_group.nsg_prod_airs_pod.id]
    }
  }

  ssh_public_key = var.stg_oke_ssh_public_key

  lifecycle {
      ignore_changes = [
        node_config_details[0].size
      ]

    precondition {
      condition     = contains(data.oci_containerengine_node_pool_option.airs_all_options.shapes, var.airs_worker_node_shape)
      error_message = "The requested worker_node_shape is not listed as a supported OKE node-pool shape in this tenancy/region."
    }

    precondition {
      condition     = local.airs_worker_node_image_id != null
      error_message = "No compatible OKE image was found in node-pool-options for the requested Kubernetes version."
    }

    precondition {
      condition     = var.airs_worker_node_min_count <= var.airs_worker_node_count && var.airs_worker_node_count <= var.airs_worker_node_max_count
      error_message = "worker_node_count must be between worker_node_min_count and worker_node_max_count."
    }
  }
}

#########################################
# IAM for Cluster Autoscaler (instance principal)
#########################################
resource "oci_identity_dynamic_group" "airs_cluster_autoscaler" {
  compartment_id = var.tenancy_ocid
  name           = "${var.airs_cluster_name}-ca-dg"
  description    = "Dynamic group for OKE Cluster Autoscaler instances"
  # Autoscaler runs on OKE nodes in prod-app-comp
  matching_rule = "ALL {instance.compartment.id = '${oci_identity_compartment.app_compartment.id}'}"
}

resource "oci_identity_policy" "airs_cluster_autoscaler" {
  compartment_id = var.tenancy_ocid

  # Change the name once if Terraform is trying to update an old wrongly-attached policy
  name        = "${var.airs_cluster_name}-ca-policy"
  description = "allow worker nodes to manage node pools"

  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.airs_cluster_autoscaler.name} to manage cluster-node-pools in compartment id ${oci_identity_compartment.app_compartment.id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.airs_cluster_autoscaler.name} to manage instance-family in compartment id ${oci_identity_compartment.app_compartment.id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.airs_cluster_autoscaler.name} to use subnets in compartment id ${oci_identity_compartment.app_compartment.id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.airs_cluster_autoscaler.name} to use vnics in compartment id ${oci_identity_compartment.app_compartment.id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.airs_cluster_autoscaler.name} to inspect compartments in compartment id ${oci_identity_compartment.app_compartment.id}",

    "Allow dynamic-group ${oci_identity_dynamic_group.airs_cluster_autoscaler.name} to use subnets in compartment id ${oci_identity_compartment.net_compartment.id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.airs_cluster_autoscaler.name} to read virtual-network-family in compartment id ${oci_identity_compartment.net_compartment.id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.airs_cluster_autoscaler.name} to use vnics in compartment id ${oci_identity_compartment.net_compartment.id}",
    "Allow dynamic-group ${oci_identity_dynamic_group.airs_cluster_autoscaler.name} to inspect compartments in compartment id ${oci_identity_compartment.net_compartment.id}"
  ]
}

resource "oci_identity_policy" "airs_enable_access_node_pool" {
  # Attach at tenancy/root
  compartment_id = var.tenancy_ocid

  name        = "${var.airs_cluster_name}-enable-access-node-pool-policy"
  description = "allow node pool management"

  statements = [
    # Permissions in prod-app-comp (OKE cluster + node pools)
    "Allow any-user to manage cluster-node-pools in compartment id ${oci_identity_compartment.app_compartment.id} where ALL {request.principal.type='workload', request.principal.namespace='kube-system', request.principal.service_account='cluster-autoscaler', request.principal.cluster_id='${oci_containerengine_cluster.stg_oke.id}'}",
    "Allow any-user to manage instance-family in compartment id ${oci_identity_compartment.app_compartment.id} where ALL {request.principal.type='workload', request.principal.namespace='kube-system', request.principal.service_account='cluster-autoscaler', request.principal.cluster_id='${oci_containerengine_cluster.stg_oke.id}'}",
    "Allow any-user to inspect compartments in compartment id ${oci_identity_compartment.app_compartment.id} where ALL {request.principal.type='workload', request.principal.namespace='kube-system', request.principal.service_account='cluster-autoscaler', request.principal.cluster_id='${oci_containerengine_cluster.stg_oke.id}'}",
    "Allow any-user to use subnets in compartment id ${oci_identity_compartment.app_compartment.id} where ALL {request.principal.type='workload', request.principal.namespace='kube-system', request.principal.service_account='cluster-autoscaler', request.principal.cluster_id='${oci_containerengine_cluster.stg_oke.id}'}",
    "Allow any-user to use vnics in compartment id ${oci_identity_compartment.app_compartment.id} where ALL {request.principal.type='workload', request.principal.namespace='kube-system', request.principal.service_account='cluster-autoscaler', request.principal.cluster_id='${oci_containerengine_cluster.stg_oke.id}'}",

    # Permissions in prod-net-comp (VCN, subnets, vnics, network metadata)
    "Allow any-user to use subnets in compartment id ${oci_identity_compartment.net_compartment.id} where ALL {request.principal.type='workload', request.principal.namespace='kube-system', request.principal.service_account='cluster-autoscaler', request.principal.cluster_id='${oci_containerengine_cluster.stg_oke.id}'}",
    "Allow any-user to read virtual-network-family in compartment id ${oci_identity_compartment.net_compartment.id} where ALL {request.principal.type='workload', request.principal.namespace='kube-system', request.principal.service_account='cluster-autoscaler', request.principal.cluster_id='${oci_containerengine_cluster.stg_oke.id}'}",
    "Allow any-user to use vnics in compartment id ${oci_identity_compartment.net_compartment.id} where ALL {request.principal.type='workload', request.principal.namespace='kube-system', request.principal.service_account='cluster-autoscaler', request.principal.cluster_id='${oci_containerengine_cluster.stg_oke.id}'}",
    "Allow any-user to inspect compartments in compartment id ${oci_identity_compartment.net_compartment.id} where ALL {request.principal.type='workload', request.principal.namespace='kube-system', request.principal.service_account='cluster-autoscaler', request.principal.cluster_id='${oci_containerengine_cluster.stg_oke.id}'}"
  ]
}



#########################################
# OKE Cluster Autoscaler add-on
# Works for ENHANCED clusters.
#########################################
resource "oci_containerengine_addon" "airs_cluster_autoscaler" {
  # count = var.enable_cluster_autoscaler && var.cluster_type == "ENHANCED_CLUSTER" ? 1 : 0

  cluster_id                        = oci_containerengine_cluster.stg_oke.id
  addon_name                        = "ClusterAutoscaler"
  remove_addon_resources_on_delete  = true
  override_existing                 = true

  configurations {
    key   = "authType"
    value = var.airs_cluster_autoscaler_auth_type
  }

  configurations {
    key   = "nodes"
    value = "${var.airs_worker_node_min_count}:${var.airs_worker_node_max_count}:${oci_containerengine_node_pool.airs_worker.id}"
  }


  configurations {
    key   = "nodeSelectors"
    value = jsonencode({
      "nodepool-role" = "system"
    })
  }

  configurations {
    key   = "numOfReplicas"
    value = tostring(var.airs_cluster_autoscaler_num_replicas)
  }

  configurations {
    key   = "maxNodeProvisionTime"
    value = var.airs_cluster_autoscaler_max_node_provision_time
  }

  configurations {
    key   = "scaleDownDelayAfterAdd"
    value = var.airs_cluster_autoscaler_scale_down_delay_after_add
  }

  configurations {
    key   = "scaleDownUnneededTime"
    value = var.airs_cluster_autoscaler_scale_down_unneeded_time
  }

  configurations {
    key   = "cordonNodeBeforeTerminating"
    value = var.airs_cordonNodeBeforeTerminating
  }

  # configurations {
  #   key   = "maxGracefulTerminationSec"
  #   value = var.cluster_autoscaler_max_graceful_termination_sec
  # }
 
  
  # # Keep these protective defaults unless you have a very specific reason to relax them
  # configurations {
  #   key   = "skipNodesWithSystemPods"
  #   value = "false"
  # }

  # configurations {
  #   key   = "skipNodesWithLocalStorage"
  #   value = "false"                # If true, cluster autoscaler will never delete nodes with pods with local storage, e.g. EmptyDir or HostPath.   
  # }


  depends_on = [
    oci_identity_policy.airs_cluster_autoscaler,
    oci_containerengine_node_pool.airs_system,
    oci_containerengine_node_pool.airs_worker
  ]

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}





