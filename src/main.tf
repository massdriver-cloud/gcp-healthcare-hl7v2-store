resource "google_healthcare_hl7_v2_store" "main" {
  name    = var.md_metadata.name_prefix
  dataset = var.dataset.data.infrastructure.grn
  labels  = var.md_metadata.default_tags

  parser_config {
    allow_null_header  = var.parser.allow_null_header
    segment_terminator = var.parser.enable_custom_segment_terminator ? base64encode(var.parser.custom_segment_terminator) : null
  }

  dynamic "notification_configs" {
    for_each = var.pubsub_topic != null ? ["pubsub"] : []
    content {
      pubsub_topic = var.pubsub_topic.data.infrastructure.grn
    }
  }
}
