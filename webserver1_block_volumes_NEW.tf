

/* resource "oci_core_volume_attachment" "FoggyKitchenWebserver1BlockVolume140G-1_attach" {
    attachment_type = "iscsi"
    compartment_id = var.compartment_ocid
    instance_id = oci_core_instance.FoggyKitchenWebserver1.id
    volume_id = oci_core_volume.FoggyKitchenWebserver1BlockVolume140G-1.id
} */

/* resource "oci_core_volume" "FoggyKitchenWebserver1BlockVolume140G-2" {
  availability_domain = var.ADs[0]
  compartment_id = var.compartment_ocid
  display_name = "SAP DB BlockVolume 140G 2/3"
  size_in_gbs = "140"
}

resource "oci_core_volume_attachment" "FoggyKitchenWebserver1BlockVolume140G-2_attach" {
    attachment_type = "iscsi"
    compartment_id = var.compartment_ocid
    instance_id = oci_core_instance.FoggyKitchenWebserver1.id
    volume_id = oci_core_volume.FoggyKitchenWebserver1BlockVolume140G-2.id
}

resource "oci_core_volume" "FoggyKitchenWebserver1BlockVolume50G-3" {
  availability_domain = var.ADs[0]
  compartment_id = var.compartment_ocid
  display_name = "SAP DB BlockVolume 50G 3/3"
  size_in_gbs = "50"
}

resource "oci_core_volume_attachment" "FoggyKitchenWebserver1BlockVolume50G-3_attach" {
    attachment_type = "iscsi"
    compartment_id = var.compartment_ocid
    instance_id = oci_core_instance.FoggyKitchenWebserver1.id
    volume_id = oci_core_volume.FoggyKitchenWebserver1BlockVolume50G-3.id
}

resource "null_resource" "FoggyKitchenWebserver1_oci_iscsi_attach" {
 depends_on = [oci_core_volume_attachment.FoggyKitchenWebserver1BlockVolume140G-2_attach,oci_core_volume_attachment.FoggyKitchenWebserver1BlockVolume50G-3_attach]

 provisioner "remote-exec" {
    connection {
                type     = "ssh"
                user     = "opc"
                host     = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.public_ip_address
                private_key = file(var.private_key_oci)
                script_path = "/home/opc/myssh.sh"
                agent = false
                timeout = "10m"
        }
     inline = ["sudo /bin/su -c \"rm -Rf /home/opc/iscsiattach.sh\""]
  }

 provisioner "file" {
    connection {
                type     = "ssh"
                user     = "opc"
                host     = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.public_ip_address
                private_key = file(var.private_key_oci)
                script_path = "/home/opc/myssh.sh"
                agent = false
                timeout = "10m"
        }
    source     = "iscsiattach.sh"
    destination = "/home/opc/iscsiattach.sh"
  }

  provisioner "remote-exec" {
            connection {
                type     = "ssh"
                user     = "opc"
                host     = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.public_ip_address
                private_key = file(var.private_key_oci)
                script_path = "/home/opc/myssh.sh"
                agent = false
                timeout = "10m"
        }
  inline = ["sudo /bin/su -c \"chown root /home/opc/iscsiattach.sh\"",
            "sudo /bin/su -c \"chmod u+x /home/opc/iscsiattach.sh\"",
            "sudo /bin/su -c \"/home/opc/iscsiattach.sh\""]
  }

} */


/* resource "null_resource" "FoggyKitchenWebserver1_oci_u01_fstab" {
 depends_on = [null_resource.FoggyKitchenWebserver1_oci_iscsi_attach]

 provisioner "remote-exec" {
        connection {
                type     = "ssh"
                user     = "opc"
                host     = data.oci_core_vnic.FoggyKitchenWebserver1_VNIC1.public_ip_address
                private_key = file(var.private_key_oci)
                script_path = "/home/opc/myssh.sh"
                agent = false
                timeout = "10m"
        }
  inline = ["sudo -u root parted /dev/sdb --script -- mklabel gpt",
            "sudo -u root parted /dev/sdc --script -- mklabel gpt",
            "sudo -u root parted /dev/sdd --script -- mklabel gpt",
            "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 0GiB 2GiB",
            "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 2GiB 46GiB",
            "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 46GiB 94GiB",
            "sudo -u root parted /dev/sdb --script -- mkpart primary ext4 94GiB 114GiB",
            "sudo -u root parted /dev/sdc --script -- mkpart primary ext4 0GiB 40GiB",
            "sudo -u root parted /dev/sdc --script -- mkpart primary ext4 40GiB 55GiB",
            "sudo -u root parted /dev/sdc --script -- mkpart primary ext4 55GiB 94GiB",
            "sudo -u root parted /dev/sdc --script -- mkpart primary ext4 94GiB 111GiB",
            "sudo -u root parted /dev/sdd --script -- mkpart primary ext4 0GiB 20GiB",
            "sudo -u root parted /dev/sdd --script -- mkpart primary ext4 20GiB 35GiB",
            "sudo -u root parted /dev/sdd --script -- mkpart primary ext4 35GiB 36GiB",
            "sudo -u root mkfs.ext4 /dev/sdb1",
            "sudo -u root mkfs.ext4 /dev/sdb2",
            "sudo -u root mkfs.ext4 /dev/sdb3",
            "sudo -u root mkfs.ext4 /dev/sdb4",
            "sudo -u root mkfs.ext4 /dev/sdc1",
            "sudo -u root mkfs.ext4 /dev/sdc2",
            "sudo -u root mkfs.ext4 /dev/sdc3",
            "sudo -u root mkfs.ext4 /dev/sdc4",
            "sudo -u root mkfs.ext4 /dev/sdd1",
            "sudo -u root mkfs.ext4 /dev/sdd2",
            "sudo -u root mkfs.ext4 /dev/sdd3",
            "sudo -u root mkdir -p /ctmuser/ctmage6",
            "sudo -u root mkdir -p /usr/sap",
            "sudo -u root mkdir -p /usr/sap/trans",
            "sudo -u root mkdir /arch00",
            "sudo -u root mkdir -p /usrt/sap/app",
            "sudo -u root mkdir /sapmnt",
            "sudo -u root mkdir /CgaHR",
            "sudo -u root mkdir -p /usr/sap/MXQ",
            "sudo -u root mkdir /MXQPaso",
            "sudo -u root mkdir -p /sapmnt/MXQ",
            "sudo -u root mkdir /delivery",
            "sudo -u root mount /dev/sdb1 /ctmuser/ctmage6",
            "sudo -u root mount /dev/sdb2 /usr/sap",
            "sudo -u root mount /dev/sdb3 /usr/sap/trans",
            "sudo -u root mount /dev/sdb4 /arch00",
            "sudo -u root mount /dev/sdc1 /usrt/sap/app",
            "sudo -u root mount /dev/sdc2 /sapmnt",
            "sudo -u root mount /dev/sdc3 /CgaHR",
            "sudo -u root mount /dev/sdc4 /usr/sap/MXQ",
            "sudo -u root mount /dev/sdd1 /MXQPaso",
            "sudo -u root mount /dev/sdd2 /sapmnt/MXQ",
            "sudo -u root mount /dev/sdd3 /delivery",
            "sudo /bin/su -c \"echo '/dev/sdb1              /ctmuser/ctmage6  ext4    defaults,noatime,_netdev    0   0' >> /etc/fstab\"",
            "sudo /bin/su -c \"echo '/dev/sdb2              /usr/sap  ext4    defaults,noatime,_netdev    0   0' >> /etc/fstab\"",
            "sudo /bin/su -c \"echo '/dev/sdb3              /usr/sap/trans  ext4    defaults,noatime,_netdev    0   0' >> /etc/fstab\"",
            "sudo /bin/su -c \"echo '/dev/sdb4              /arch00  ext4    defaults,noatime,_netdev    0   0' >> /etc/fstab\"",
            "sudo /bin/su -c \"echo '/dev/sdc1              /usrt/sap/app  ext4    defaults,noatime,_netdev    0   0' >> /etc/fstab\"",
            "sudo /bin/su -c \"echo '/dev/sdc2              /sapmnt  ext4    defaults,noatime,_netdev    0   0' >> /etc/fstab\"",
            "sudo /bin/su -c \"echo '/dev/sdc3              /CgaHR  ext4    defaults,noatime,_netdev    0   0' >> /etc/fstab\"",
            "sudo /bin/su -c \"echo '/dev/sdc4              /usr/sap/MXQ  ext4    defaults,noatime,_netdev    0   0' >> /etc/fstab\"",

           ]
  }

} */



