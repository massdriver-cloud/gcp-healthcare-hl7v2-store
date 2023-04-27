resource "massdriver_artifact" "hl7v2_store" {
  field                = "hl7v2_store"
  provider_resource_id = google_healthcare_hl7_v2_store.main.id
  name                 = "GCP Healthcare HL7v2 Store ${var.md_metadata.name_prefix}"
  artifact = jsonencode(
    {
      data = {
        infrastructure = {
          grn = google_healthcare_hl7_v2_store.main.id
        }
        security = {
          iam = {
            read = {
              role      = "roles/healthcare.hl7V2Consumer"
              condition = "resource.name.endsWith(\"${var.md_metadata.name_prefix}\")"
            }
            read_write = {
              role      = "roles/healthcare.hl7V2Editor"
              condition = "resource.name.endsWith(\"${var.md_metadata.name_prefix}\")"
            }
            admin = {
              role      = "roles/healthcare.hl7V2StoreAdmin"
              condition = "resource.name.endsWith(\"${var.md_metadata.name_prefix}\")"
            }
          }
        }
      }
      specs = {
        gcp = {
          region = var.dataset.specs.gcp.region
        }
      }
    }
  )
}
