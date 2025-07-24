# terraform-oci-compute
Compute instance terraform module

# Listing available images

To set the proper image OCID, you can query the available images from your tenant based on your root compartment OCID : 

```bash
export ROOT_COMPARTMENT_OCID="ocid1.compartment.oc1.."
oci compute image list   --compartment-id <ROOT_COMPARTMENT_OCID>   --operating-system "Oracle Linux"   --all   --query "data[?contains(\"display-name\",'Oracle-Linux')].{Name:\"display-name\",OCID:id,OS:\"operating-system\",Version:\"operating-system-version\"}"   --output table
```