resource "oci_ons_notification_topic" "network_alert_topic" {
  compartment_id = oci_identity_compartment.net_compartment.id
  name           = "network_changes_alert"
}

resource "oci_ons_subscription" "email_subscription" {
  depends_on = [ oci_ons_notification_topic.network_alert_topic ]
  for_each = toset(var.alert_email)
  compartment_id = oci_identity_compartment.net_compartment.id
  endpoint       = each.value
  protocol       = "EMAIL"
  topic_id       = oci_ons_notification_topic.network_alert_topic.id
  # lifecycle {
  #   ignore_changes = [state, etag]
  # }
}

resource "oci_events_rule" "network_security_change_rule" {

  compartment_id = oci_identity_compartment.net_compartment.id
  display_name   = "network-Infra-change-detection"
  is_enabled     = true

  condition = jsonencode({
    "eventType": [
      "com.oraclecloud.virtualnetwork.addnetworksecuritygroupsecurityrules",
      "com.oraclecloud.virtualnetwork.updatenetworksecuritygroupsecurityrules",

      "com.oraclecloud.virtualnetwork.changenetworksecuritygroupcompartment",
      "com.oraclecloud.virtualnetwork.updatenetworksecuritygroup",
      "com.oraclecloud.virtualnetwork.createnetworksecuritygroup",
      "com.oraclecloud.virtualnetwork.deletenetworksecuritygroup",

      "com.oraclecloud.virtualnetwork.updatesubnet",
      "com.oraclecloud.virtualnetwork.createsubnet",
      "com.oraclecloud.virtualnetwork.deletesubnet",

      "com.oraclecloud.virtualnetwork.changeroutetablecompartment",
      "com.oraclecloud.virtualnetwork.updateroutetable",
      "com.oraclecloud.virtualnetwork.deleteroutetable",
      "com.oraclecloud.virtualnetwork.createroutetable",
  
      "com.oraclecloud.virtualnetwork.changesecuritylistcompartment",
      "com.oraclecloud.virtualnetwork.updatesecuritylist",
      "com.oraclecloud.virtualnetwork.deletesecuritylist",
      "com.oraclecloud.virtualnetwork.createsecuritylist",

      "com.oraclecloud.virtualnetwork.changeinternetgatewaycompartment",
      "com.oraclecloud.virtualnetwork.createinternetgateway",
      "com.oraclecloud.virtualnetwork.deleteinternetgateway",
      "com.oraclecloud.virtualnetwork.updateinternetgateway",

      "com.oraclecloud.natgateway.changenatgatewaycompartment",
      "com.oraclecloud.natgateway.createnatgateway",
      "com.oraclecloud.natgateway.deletenatgateway",
      "com.oraclecloud.natgateway.updatenatgateway",

      "com.oraclecloud.virtualnetwork.changepublicipcompartment",
      "com.oraclecloud.virtualnetwork.createpublicip",
      "com.oraclecloud.virtualnetwork.deletepublicip",
      "com.oraclecloud.virtualnetwork.updatepublicip",
 
      "com.oraclecloud.servicegateway.attachserviceid",
      "com.oraclecloud.servicegateway.changeservicegatewaycompartment",
      "com.oraclecloud.servicegateway.createservicegateway",
      "com.oraclecloud.servicegateway.updateservicegateway",
      "com.oraclecloud.servicegateway.detachserviceid",
      "com.oraclecloud.servicegateway.deleteservicegateway.begin",
      "com.oraclecloud.servicegateway.deleteservicegateway.end",

      "com.oraclecloud.virtualnetwork.createvcn",
      "com.oraclecloud.virtualnetwork.deletevcn",
      "com.oraclecloud.virtualnetwork.updatevcn",
      "com.oraclecloud.virtualnetwork.updatevnic",

      "com.oraclecloud.virtualnetwork.updatelocalpeeringgateway",
      "com.oraclecloud.virtualnetwork.deletelocalpeeringgateway.end",
      "com.oraclecloud.virtualnetwork.deletelocalpeeringgateway.begin",
      "com.oraclecloud.virtualnetwork.deletelocalpeeringgateway",
      "com.oraclecloud.virtualnetwork.createlocalpeeringgateway",

      "com.oraclecloud.virtualnetwork.updatedrg",
      "com.oraclecloud.virtualnetwork.deletedrg",
      "com.oraclecloud.virtualnetwork.createdrg",
      "com.oraclecloud.virtualnetwork.createdrgattachment",
      "com.oraclecloud.virtualnetwork.deletedrgattachment",
      "com.oraclecloud.virtualnetwork.updatedrgattachment",

      "com.oraclecloud.virtualnetwork.updatedhcpoptions",
      "com.oraclecloud.virtualnetwork.deletedhcpoptions",
      "com.oraclecloud.virtualnetwork.changedhcpoptionscompartment",
      "com.oraclecloud.virtualnetwork.createdhcpoptions",

      
    ]
  })

  actions {
    actions {
      action_type = "ONS"
      topic_id    = oci_ons_notification_topic.network_alert_topic.id
      is_enabled  = true
    }
  }
}