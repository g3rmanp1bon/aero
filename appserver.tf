resource "oci_core_instance" "SAP-AppServer" {
    #Required
    availability_domain = var.ADs[0]
    compartment_id = var.compartment_ocid
    display_name = "SAP-AppServer"
    shape = "VM.Standard2.1"

    create_vnic_details {
        #Required
        subnet_id = var.subnet
        #Optional
        assign_public_ip = false
    }

    source_details {
        #Required
        source_id = var.Images[1]
        source_type = "image"
    }

    metadata = {
        ssh_authorized_keys = file(var.public_key_oci)
    }            
}

data "oci_core_vnic_attachments" "SAP-AppServer_VNIC1_attach" {
  availability_domain = var.ADs[0]
  compartment_id = var.compartment_ocid
  instance_id = oci_core_instance.SAP-AppServer.id
}

data "oci_core_vnic" "SAP-AppServer_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.SAP-AppServer_VNIC1_attach.vnic_attachments.0.vnic_id
}

/* resource "oci_core_volume" "vol1" {
    #count = length(var.volumes)
    #Required
    availability_domain = var.ADs[0]
    compartment_id = var.compartment_ocid

    #Optional
    display_name = "SAP App BlockVolume 160G 1/2"
    size_in_gbs = 160
}

resource "oci_core_volume" "vol2" {
    #Required
    availability_domain = var.ADs[0]
    compartment_id = var.compartment_ocid

    #Optional
    display_name = "SAP App BlockVolume 180G 2/2"
    size_in_gbs = 180
} 

resource "oci_core_volume_attachment" "volattach1" {
  #count = length(var.volumes)
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.SAP-AppServer.id
  volume_id       = oci_core_volume.vol1.id #[count.index].id

  connection {
    type        = "ssh"
    host        = oci_core_instance.SAP-AppServer.private_ip
    user        = "opc"
    private_key = file(var.private_key_oci)
    timeout = "5m"
  }
    

    # register and connect the iSCSI block volume
    provisioner "remote-exec" {
        inline = [
        "sudo iscsiadm -m node -o new -T ${self.iqn} -p ${self.ipv4}:${self.port}",
        "sudo iscsiadm -m node -o update -T ${self.iqn} -n node.startup -v automatic",
        "sudo iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -l",
        ]
    }


    provisioner "remote-exec" {
        inline = [
            "set -x",
            "export DEVICE_ID=ip-${self.ipv4}:${self.port}-iscsi-${self.iqn}-lun-1",
            "sudo -u root parted /dev/sdb --script -- mklabel gpt",
            "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 1MiB 6GiB",
            "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 6GiB 21GiB",
            "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 21GiB 65GiB",
            "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 65GiB 105GiB",
            "sudo -u root mkfs.ext4 /dev/sdb1",
            "sudo -u root mkfs.ext4 /dev/sdb2",
            "sudo -u root mkfs.ext4 /dev/sdb3",
            "sudo -u root mkfs.ext4 /dev/sdb4",
            "sudo -u root mkdir -p /oracle /usr/sap/QAS /usr/sap/put /usr/sap/app",
            "sudo -u root mount /dev/sdb1 /oracle",
            "sudo -u root mount /dev/sdb2 /usr/sap/QAS",
            "sudo -u root mount /dev/sdb3 /usr/sap/put",
            "sudo -u root mount /dev/sdb4 /usr/sap/app",
            "echo '/dev/sdb1        /oracle  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdb2        /usr/sap/QAS  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdb3        /usr/sap/put  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdb4        /usr/sap/app  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab"
        ]
    }
} 

resource "oci_core_volume_attachment" "volattach2" {
  #count = length(var.volumes)
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.SAP-AppServer.id
  volume_id       = oci_core_volume.vol2.id #[count.index].id

  connection {
    type        = "ssh"
    host        = oci_core_instance.SAP-AppServer.private_ip
    user        = "opc"
    private_key = file(var.private_key_oci)
    timeout = "5m"
  }
    

    # register and connect the iSCSI block volume
    provisioner "remote-exec" {
        inline = [
        "sudo iscsiadm -m node -o new -T ${self.iqn} -p ${self.ipv4}:${self.port}",
        "sudo iscsiadm -m node -o update -T ${self.iqn} -n node.startup -v automatic",
        "sudo iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -l",
        ]
    }


    provisioner "remote-exec" {
        inline = [
            "set -x",
            "export DEVICE_ID=ip-${self.ipv4}:${self.port}-iscsi-${self.iqn}-lun-1",
            "sudo -u root parted /dev/sdc --script -- mklabel gpt",
            "sudo -u root parted /dev/sdc --script -- mkpart primary ext4 1MiB 16GiB",
            "sudo -u root parted /dev/sdc --script -- mkpart primary ext4 16GiB 64GiB",
            "sudo -u root parted /dev/sdc --script -- mkpart primary ext4 64GiB 84GiB",
            "sudo -u root parted /dev/sdc --script -- mkpart primary ext4 84GiB 123GiB",
            "sudo -u root mkfs.ext4 /dev/sdc1",
            "sudo -u root mkfs.ext4 /dev/sdc2",
            "sudo -u root mkfs.ext4 /dev/sdc3",
            "sudo -u root mkfs.ext4 /dev/sdc4",
            "sudo -u root mkdir -p /sapmnt /usr/sap/trans /archj00 /CgaHR",
            "sudo -u root mount /dev/sdc1 /sapmnt",
            "sudo -u root mount /dev/sdc2 /usr/sap/trans",
            "sudo -u root mount /dev/sdc3 /archj00",
            "sudo -u root mount /dev/sdc4 /CgaHR",
            "echo '/dev/sdc1        /sapmnt  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdc2        /usr/sap/trans  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdc3        /archj00  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdc4        /CgaHR  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab"
        ]
    }
}  */