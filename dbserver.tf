resource "oci_core_instance" "SAP-DBServer" {
    #Required
    availability_domain = var.ADs[0]
    compartment_id = var.compartment_ocid
    display_name = "SAP-DBServer"
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

data "oci_core_vnic_attachments" "SAP-DBServer_VNIC1_attach" {
  availability_domain = var.ADs[0]
  compartment_id = var.compartment_ocid
  instance_id = oci_core_instance.SAP-DBServer.id
}

data "oci_core_vnic" "SAP-DBServer_VNIC1" {
  vnic_id = data.oci_core_vnic_attachments.SAP-DBServer_VNIC1_attach.vnic_attachments.0.vnic_id
}

/* resource "oci_core_volume" "SAPBlockVolume140G-1" {
  availability_domain = var.ADs[0]
  compartment_id = var.compartment_ocid
  display_name = "SAP DB BlockVolume 140G 1/4"
  size_in_gbs = "140"
}


resource "oci_core_volume" "SAPBlockVolume140G-2" {
  availability_domain = var.ADs[0]
  compartment_id = var.compartment_ocid
  display_name = "SAP DB BlockVolume 140G 2/4"
  size_in_gbs = "140"
}

resource "oci_core_volume" "SAPBlockVolume80G" {
  availability_domain = var.ADs[0]
  compartment_id = var.compartment_ocid
  display_name = "SAP DB BlockVolume 80G 3/4"
  size_in_gbs = "80"
}

resource "oci_core_volume" "SAPBlockVolume120G" {
  availability_domain = var.ADs[0]
  compartment_id = var.compartment_ocid
  display_name = "SAP DB BlockVolume 120G 4/4"
  size_in_gbs = "120"
}

resource "oci_core_volume_attachment" "SAPBlockVolume140G-1" {
  #count = length(var.volumes)
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.SAP-DBServer.id
  volume_id       = oci_core_volume.SAPBlockVolume140G-1.id #[count.index].id

  connection {
    type        = "ssh"
    host        = oci_core_instance.SAP-DBServer.private_ip
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
            "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 1MiB 2GiB",
            "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 2GiB 46GiB",
            "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 46GiB 94GiB",
            "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 94GiB 114GiB",
            "sudo -u root mkfs.ext4 /dev/sdb1",
            "sudo -u root mkfs.ext4 /dev/sdb2",
            "sudo -u root mkfs.ext4 /dev/sdb3",
            "sudo -u root mkfs.ext4 /dev/sdb4",
            "sudo -u root mkdir -p /ctmuser/ctmage6",
            "sudo -u root mkdir -p /usr/sap",
            "sudo -u root mkdir -p /usr/sap/trans",
            "sudo -u root mkdir /arch00",
            "sudo -u root mount /dev/sdb1 /ctmuser/ctmage6",
            "sudo -u root mount /dev/sdb2 /usr/sap",
            "sudo -u root mount /dev/sdb3 /usr/sap/trans",
            "sudo -u root mount /dev/sdb4 /arch00",
            "echo '/dev/sdb1        /ctmuser/ctmage6  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdb2        /usr/sap  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdb3        /usr/sap/trans  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdb4        /arch00  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab"
        ]
    }
} 

resource "oci_core_volume_attachment" "SAPBlockVolume140G-2" {
  #count = length(var.volumes)
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.SAP-DBServer.id
  volume_id       = oci_core_volume.SAPBlockVolume140G-2.id #[count.index].id

  connection {
    type        = "ssh"
    host        = oci_core_instance.SAP-DBServer.private_ip
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
            "sudo -u root parted /dev/sdc --script -- mkpart primary ext4 1MiB 40GiB",
            "sudo -u root parted /dev/sdc --script -- mkpart primary ext4 40GiB 55GiB",
            "sudo -u root parted /dev/sdc --script -- mkpart primary ext4 55GiB 94GiB",
            "sudo -u root parted /dev/sdc --script -- mkpart primary ext4 94GiB 111GiB",
            "sudo -u root mkfs.ext4 /dev/sdc1",
            "sudo -u root mkfs.ext4 /dev/sdc2",
            "sudo -u root mkfs.ext4 /dev/sdc3",
            "sudo -u root mkfs.ext4 /dev/sdc4",
            "sudo -u root mkdir -p /usrt/sap/app",
            "sudo -u root mkdir /sapmnt",
            "sudo -u root mkdir /CgaHR",
            "sudo -u root mkdir -p /usr/sap/MXQ",
            "sudo -u root mount /dev/sdc1 /usrt/sap/app",
            "sudo -u root mount /dev/sdc2 /sapmnt",
            "sudo -u root mount /dev/sdc3 /CgaHR",
            "sudo -u root mount /dev/sdc4 /usr/sap/MXQ",
            "echo '/dev/sdc1        /usrt/sap/app  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdc2        /sapmnt  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdc3        /CgaHR  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdc4        /usr/sap/MXQ  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab"
        ]
    }
} 

resource "oci_core_volume_attachment" "SAPBlockVolume80G" {
  #count = length(var.volumes)
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.SAP-DBServer.id
  volume_id       = oci_core_volume.SAPBlockVolume80G.id #[count.index].id

  connection {
    type        = "ssh"
    host        = oci_core_instance.SAP-DBServer.private_ip
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
            "sudo -u root parted /dev/sdd --script -- mklabel gpt",
            "sudo -u root parted /dev/sdd --script -- mkpart primary ext4 1MiB 20GiB",
            "sudo -u root parted /dev/sdd --script -- mkpart primary ext4 20GiB 35GiB",
            "sudo -u root parted /dev/sdd --script -- mkpart primary ext4 35GiB 36GiB",            
            "sudo -u root parted /dev/sdd --script -- mkpart primary ext4 36GiB 56GiB",
            "sudo -u root mkfs.ext4 /dev/sdd1",
            "sudo -u root mkfs.ext4 /dev/sdd2",
            "sudo -u root mkfs.ext4 /dev/sdd3",
            "sudo -u root mkfs.ext4 /dev/sdd4",
            "sudo -u root mkdir /MXQPaso",
            "sudo -u root mkdir -p /sapmnt/MXQ",
            "sudo -u root mkdir /delivery",
            "sudo -u root mkdir -p /usr/sap/MXQ",
            "sudo -u root mkdir -p /oracle",
            "sudo -u root mount /dev/sdd1 /MXQPaso",
            "sudo -u root mount /dev/sdd2 /sapmnt/MXQ",
            "sudo -u root mount /dev/sdd3 /delivery",
            "sudo -u root mount /dev/sdd4 /oracle",
            "echo '/dev/sdd1        /MXQPaso  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdd2        /sapmnt/MXQ  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdd3        /delivery  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sdd4        /oracle  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab"
        ]
    }
} 

resource "oci_core_volume_attachment" "SAPBlockVolume120G" {
  #count = length(var.volumes)
  attachment_type = "iscsi"
  instance_id     = oci_core_instance.SAP-DBServer.id
  volume_id       = oci_core_volume.SAPBlockVolume120G.id #[count.index].id

  connection {
    type        = "ssh"
    host        = oci_core_instance.SAP-DBServer.private_ip
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
            "sudo -u root parted /dev/sde --script -- mklabel gpt",
            "sudo -u root parted /dev/sde --script -- mkpart primary ext4 1MiB 20GiB",
            "sudo -u root parted /dev/sde --script -- mkpart primary ext4 20GiB 34GiB",
            "sudo -u root parted /dev/sde --script -- mkpart primary ext4 34GiB 103GiB",            
            "sudo -u root parted /dev/sde --script -- mkpart primary ext4 103GiB 115GiB",
            "sudo -u root mkfs.ext4 /dev/sde1",
            "sudo -u root mkfs.ext4 /dev/sde2",
            "sudo -u root mkfs.ext4 /dev/sde3",
            "sudo -u root mkfs.ext4 /dev/sde4",
            "sudo -u root mkdir -p /oracle/MXQ/11203",
            "sudo -u root mkdir -p /oracle/GRID/11203",
            "sudo -u root mkdir -p /oracle/QAS/oraarch",
            "sudo -u root mkdir -p /oracle/QAS/11203",
            "sudo -u root mount /dev/sde1 /oracle/MXQ/11203",
            "sudo -u root mount /dev/sde2 /oracle/GRID/11203",
            "sudo -u root mount /dev/sde3 /oracle/QAS/oraarch",
            "sudo -u root mount /dev/sde4 /oracle/QAS/11203",
            "echo '/dev/sde1        /oracle/MXQ/11203  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sde2        /oracle/GRID/11203  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sde3        /oracle/QAS/oraarch  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab",
            "echo '/dev/sde4        /oracle/QAS/11203  ext4    defaults,noatime,_netdev    0   0' | sudo tee -a /etc/fstab"
        ]
    }
} */