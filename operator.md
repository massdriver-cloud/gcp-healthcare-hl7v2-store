## Google Cloud Healthcare HL7v2 Store

The Google Cloud Healthcare HL7v2 Store is a managed service that allows for storing, processing, and managing HL7v2 messages within Google Cloud. HL7v2 is a commonly used healthcare data exchange standard, and this service ensures that your messages are efficiently managed, secure, and interoperable with other systems and datasets.

### Design Decisions

1. **IAM Roles and Permissions**: 
    - Three levels of access are provided: `read`, `read_write`, and `admin`.
    - Conditions are used to ensure access is specific to resources with a specific naming prefix.

2. **Service Account for Pub/Sub**:
    - A Google Cloud service account is configured to publish messages to Pub/Sub if a Pub/Sub topic is provided.

3. **Parser Configurations**:
    - Supports custom parser configurations such as allowing null headers and setting custom segment terminators.
    
4. **Notification Configurations**:
    - Automatically configures notification settings for Pub/Sub if a Pub/Sub topic is specified.

### Runbook

#### Unable to Access HL7v2 Store Data

If you are experiencing permission issues or are unable to access the data, verify the IAM roles and permissions.

List IAM policies for your HL7v2 store:

```sh
gcloud healthcare hl7v2-stores get-iam-policy [HL7V2_STORE_ID] --location=[LOCATION] --dataset=[DATASET_ID]
```

Make sure the necessary roles (`roles/healthcare.hl7V2Consumer`, `roles/healthcare.hl7V2Editor`, `roles/healthcare.hl7V2StoreAdmin`) are assigned as needed.

#### Messages Not Being Parsed Correctly

If messages are not being parsed as expected, verify the parser configurations.

Check current parser configurations:

```sh
gcloud healthcare hl7v2-stores describe [HL7V2_STORE_ID] --location=[LOCATION] --dataset=[DATASET_ID]
```

Ensure that `allow_null_header` and `segment_terminator` settings match your requirements.

#### Pub/Sub Notifications Not Received

If messages are not triggering Pub/Sub notifications, check the Pub/Sub configuration and IAM permissions.

Verify Pub/Sub connection:

```sh
gcloud pubsub topics list-subscriptions [PUBSUB_TOPIC]
gcloud pubsub subscriptions pull [SUBSCRIPTION_NAME] --auto-ack
```

Ensure the service account has the `pubsub.publisher` role:

```sh
gcloud projects get-iam-policy [PROJECT_ID] --flatten="bindings[].members" --filter="bindings.role:roles/pubsub.publisher"
```

#### General Connectivity Issues

If you encounter general connectivity issues, verify the network configurations and firewall settings.

Check firewall rules and ensure no rules are blocking healthcare API access:

```sh
gcloud compute firewall-rules list --filter="name~'default-allow-healthcare'"
```

Verify that your Google Cloud project and associated service accounts have the required APIs enabled:

```sh
gcloud services list --enabled
```

Make sure `healthcare.googleapis.com` is listed in the enabled services.

