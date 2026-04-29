resource "oci_redis_redis_cluster" "redis" {
  compartment_id      = oci_identity_compartment.data_compartment.id
  display_name        = var.redis_display_name
  node_count          = var.node_count
  node_memory_in_gbs  = var.node_memory_in_gbs
  software_version    = var.software_version
  subnet_id           = oci_core_subnet.db_sub.id

  cluster_mode            = var.cluster_mode
  shard_count             = var.cluster_mode == "SHARDED" ? var.shard_count : null
  nsg_ids                 = [oci_core_network_security_group.nsg_prod_redis.id]

  oci_cache_config_set_id = var.oci_cache_config_set_id
#   defined_tags            = var.defined_tags
  freeform_tags           = var.freeform_tags
}

data "oci_redis_redis_cluster" "redis" {
  redis_cluster_id = oci_redis_redis_cluster.redis.id
}