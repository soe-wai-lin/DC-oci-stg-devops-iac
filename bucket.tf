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
## DR Protection Group Bucket  ###
########################

resource "oci_objectstorage_bucket" "dr_protection_bucket" {
  compartment_id = oci_identity_compartment.mgmt_compartment.id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = var.dr_protection_bucket_name

  access_type           = var.dr_protection_access_type
  storage_tier          = var.dr_protection_storage_tier
  auto_tiering          = var.dr_protection_auto_tiering
  versioning            = var.dr_protection_versioning
  object_events_enabled = var.dr_protection_object_events_enabled
  kms_key_id            = var.dr_protection_kms_key_id
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
## Loki Buckets  ###
########################

resource "oci_objectstorage_bucket" "loki_chucks_bucket" {
  compartment_id = oci_identity_compartment.data_compartment.id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = var.loki_chucks_bucket_name

  access_type           = var.loki_chucks_access_type
  storage_tier          = var.loki_chucks_storage_tier
  auto_tiering          = var.loki_chucks_auto_tiering
  versioning            = var.loki_chucks_versioning
  object_events_enabled = var.loki_chucks_object_events_enabled
  kms_key_id            = var.loki_chucks_kms_key_id
  metadata              = var.metadata
  freeform_tags         = var.freeform_tags
}

resource "oci_objectstorage_bucket" "loki_ruler_bucket" {
  compartment_id = oci_identity_compartment.data_compartment.id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = var.loki_ruler_bucket_name

  access_type           = var.loki_ruler_access_type
  storage_tier          = var.loki_ruler_storage_tier
  auto_tiering          = var.loki_ruler_auto_tiering
  versioning            = var.loki_ruler_versioning
  object_events_enabled = var.loki_ruler_object_events_enabled
  kms_key_id            = var.loki_ruler_kms_key_id
  metadata              = var.metadata
  freeform_tags         = var.freeform_tags
}

resource "oci_objectstorage_bucket" "loki_admin_bucket" {
  compartment_id = oci_identity_compartment.data_compartment.id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = var.loki_admin_bucket_name

  access_type           = var.loki_admin_access_type
  storage_tier          = var.loki_admin_storage_tier
  auto_tiering          = var.loki_admin_auto_tiering
  versioning            = var.loki_admin_versioning
  object_events_enabled = var.loki_admin_object_events_enabled
  kms_key_id            = var.loki_admin_kms_key_id
  metadata              = var.metadata
  freeform_tags         = var.freeform_tags
}

resource "oci_objectstorage_bucket" "tempo_bucket" {
  compartment_id = oci_identity_compartment.data_compartment.id
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  name           = var.tempo_bucket_name

  access_type           = var.tempo_access_type
  storage_tier          = var.tempo_storage_tier
  auto_tiering          = var.tempo_auto_tiering
  versioning            = var.tempo_versioning
  object_events_enabled = var.tempo_object_events_enabled
  kms_key_id            = var.tempo_kms_key_id
  metadata              = var.metadata
  freeform_tags         = var.freeform_tags
}

