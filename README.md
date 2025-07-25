# terraform-oci-compute
Compute instance terraform module

# Listing available images

To set the proper image OCID, you can query the available images from your tenant based on your root compartment OCID : 

```bash
export ROOT_COMPARTMENT_OCID="ocid1.compartment.oc1.."
oci compute image list   --compartment-id $ROOT_COMPARTMENT_OCID   --operating-system "Oracle Linux"   --all   --query "data[?contains(\"display-name\",'Oracle-Linux')].{Name:\"display-name\",OCID:id,OS:\"operating-system\",Version:\"operating-system-version\"}"   --output table
```

# Create custom image

```bash
export COMPARTMENT_ID="ocid1.compartment.oc1.."
export IMAGE_NAME="custom-image-$(date +%F)"
export INSTANCE_ID="ocid1.instance.oc1.iad."

oci compute image create \
  --compartment-id $COMPARTMENT_ID \
  --display-name $IMAGE_NAME \
  --instance-id $INSTANCE_ID \
  --launch-mode NATIVE \
  --wait-for-state AVAILABLE
```