data "oci_objectstorage_namespace" "ns" {
  compartment_id = oci_identity_compartment.data_compartment.id
}

resource "oci_objectstorage_bucket" "bucket" {
  compartment_id = oci_identity_compartment.data_compartment.id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = var.bucket_name

  access_type           = var.access_type
  storage_tier          = var.storage_tier
  auto_tiering          = var.auto_tiering
  versioning            = var.versioning
  object_events_enabled = var.object_events_enabled
  kms_key_id            = var.kms_key_id
  metadata              = var.metadata
  freeform_tags         = var.freeform_tags
}

data "oci_objectstorage_bucket" "bucket" {
  name      = oci_objectstorage_bucket.bucket.name
  namespace = data.oci_objectstorage_namespace.ns.namespace
}

########################
## Authentik Bucket  ###
########################

resource "oci_objectstorage_bucket" "authentik_bucket" {
  compartment_id = oci_identity_compartment.data_compartment.id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = var.authentik_bucket_name

  access_type           = var.authentik_access_type
  storage_tier          = var.authentik_storage_tier
  auto_tiering          = var.authentik_auto_tiering
  versioning            = var.authentik_versioning
  object_events_enabled = var.authentik_object_events_enabled
  kms_key_id            = var.authentik_kms_key_id
  metadata              = var.metadata
  freeform_tags         = var.freeform_tags
}

#####################################
## IAM Policy for Authentik Bucket ##
#####################################

resource "oci_identity_policy" "authentik_bucket_policy" {
  name           = "authentik_bucket_policy"
  compartment_id = var.tenancy_ocid
  provider = oci.home
  description    = "Policy to allow access to the Authentik Object Storage bucket."

  statements = [
    "Allow group ABDigital to manage object-family in compartment id ${oci_identity_compartment.data_compartment.id} where target.bucket.name='${oci_objectstorage_bucket.authentik_bucket.name}'",
    "Allow group ABDigital-Developer to manage object-family in compartment id ${oci_identity_compartment.data_compartment.id} where target.bucket.name='${oci_objectstorage_bucket.authentik_bucket.name}'"
  ]
}

########################
## Loki Bucket  ###
########################

resource "oci_objectstorage_bucket" "loki_bucket" {
  compartment_id = oci_identity_compartment.data_compartment.id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = var.loki_bucket_name

  access_type           = var.loki_access_type
  storage_tier          = var.loki_storage_tier
  auto_tiering          = var.loki_auto_tiering
  versioning            = var.loki_versioning
  object_events_enabled = var.loki_object_events_enabled
  kms_key_id            = var.loki_kms_key_id
  metadata              = var.metadata
  freeform_tags         = var.freeform_tags
}

# #####################################
# ## IAM Policy for loki Bucket ##
# #####################################

# resource "oci_identity_policy" "loki_bucket_policy" {
#   name           = "${var.vcn_display_name}-loki_bucket_policy"
#   compartment_id = var.tenancy_ocid
#   provider = oci.home
#   description    = "Policy to allow access to the loki Object Storage bucket."

#   statements = [
#     "Allow group ABDigital to manage object-family in compartment id ${oci_identity_compartment.data_compartment.id} where target.bucket.name='${oci_objectstorage_bucket.loki_bucket.name}'",
#     "Allow group ABDigital-Developer to manage object-family in compartment id ${oci_identity_compartment.data_compartment.id} where target.bucket.name='${oci_objectstorage_bucket.loki_bucket.name}'"
#   ]
# }

