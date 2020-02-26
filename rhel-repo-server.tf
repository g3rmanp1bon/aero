/* resource "oci_core_instance" "RHEL-reposerver" {
  availability_domain = var.ADs[0]
  compartment_id = var.compartment_ocid
  display_name = "RHEL-reposerver"
  shape = var.Shapes[0]
  subnet_id = var.subnet
  source_details {
    source_type = "image"
    # OL 7.7
    source_id   = var.Images[0]
  }
  metadata = {
      ssh_authorized_keys = file(var.public_key_oci)
  }
  create_vnic_details {
     subnet_id = var.subnet
     assign_public_ip = true
  }
}

data "oci_core_vnic_attachments" "RHEL-reposerver_VNIC1_attach" {
  availability_domain = var.ADs[0]
  compartment_id = var.compartment_ocid
  instance_id = oci_core_instance.RHEL-reposerver.id
}

data "oci_core_vnic" "RHEL-reposerver_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.RHEL-reposerver_VNIC1_attach.vnic_attachments.0.vnic_id
}

output "RHEL-reposerver_PrivateIP" {
   value = [data.oci_core_vnic.RHEL-reposerver_VNIC1.private_ip_address]
}

output "RHEL-reposerver_PublicIP" {
   value = [data.oci_core_vnic.RHEL-reposerver_VNIC1.public_ip_address]
} */