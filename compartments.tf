resource "oci_identity_compartment" "net_compartment" {
  #Required
  provider = oci.home
  compartment_id = var.compartment_id
  description    = var.net_compartment_description
  name           = var.net_comp
  enable_delete  = false ## if you destroy, this compartment name will not be delete.
  freeform_tags  = var.freeform_tags
}

resource "oci_identity_compartment" "app_compartment" {
  #Required
  provider = oci.home
  compartment_id = var.compartment_id
  description    = var.app_compartment_description
  name           = var.app_comp
  enable_delete  = false ## if you destroy, this compartment name will not be delete.
  freeform_tags  = var.freeform_tags
}

resource "oci_identity_compartment" "data_compartment" {
  #Required
  provider = oci.home
  compartment_id = var.compartment_id
  description    = var.data_compartment_description
  name           = var.data_comp
  enable_delete  = false ## if you destroy, this compartment name will not be delete.
  freeform_tags  = var.freeform_tags
}

resource "oci_identity_compartment" "mgmt_compartment" {
  #Required
  provider = oci.home
  compartment_id = var.compartment_id
  description    = var.mgmt_compartment_description
  name           = var.mgmt_comp
  enable_delete  = false ## if you destroy, this compartment name will not be delete.
  freeform_tags  = var.freeform_tags
}