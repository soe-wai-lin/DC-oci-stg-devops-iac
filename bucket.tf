# data "oci_objectstorage_namespace" "ns" {
#   compartment_id = oci_identity_compartment.data_compartment.id
# }

# resource "oci_objectstorage_bucket" "bucket" {
#   compartment_id = oci_identity_compartment.data_compartment.id
#   namespace      = data.oci_objectstorage_namespace.ns.namespace
#   name           = var.bucket_name

#   access_type           = var.access_type
#   storage_tier          = var.storage_tier
#   auto_tiering          = var.auto_tiering
#   versioning            = var.versioning
#   object_events_enabled = var.object_events_enabled
#   kms_key_id            = var.kms_key_id
#   metadata              = var.metadata
#   freeform_tags         = var.freeform_tags
# }

# data "oci_objectstorage_bucket" "bucket" {
#   name      = oci_objectstorage_bucket.bucket.name
#   namespace = data.oci_objectstorage_namespace.ns.namespace
# }
