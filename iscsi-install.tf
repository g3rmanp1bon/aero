resource "null_resource" "SAP-AppServer-iscsi" {
depends_on = [oci_core_instance.SAP-AppServer]

        provisioner "remote-exec" {
                connection {
                        type     = "ssh"
                        user     = "opc"
                        host     = data.oci_core_vnic.SAP-AppServer_VNIC1.private_ip_address
                        private_key = file(var.private_key_oci)
                        script_path = "/home/opc/myssh.sh"
                        agent = false
                        timeout = "10m"
                }
        
                inline = [
                        "sudo -u root wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/_xNmt7caueWzV10qJ58_A4b0CUH003H9azUUexJBLag/n/idpjujruxnw2/b/vmdk/o/rhel-server-6.10-x86_64-dvd.iso",
                        "sudo -u root mount -o loop rhel-server-6.10-x86_64-dvd.iso /mnt",
                        "sudo -u root yum install /mnt/Packages/iscsi-initiator-utils-6.2.0.873-27.el6_9.x86_64.rpm"
                        ]
        } 
}

resource "null_resource" "SAP-DBServer-iscsi" {
depends_on = [oci_core_instance.SAP-DBServer]

        provisioner "remote-exec" {
                connection {
                        type     = "ssh"
                        user     = "opc"
                        host     = data.oci_core_vnic.SAP-DBServer_VNIC1.private_ip_address
                        private_key = file(var.private_key_oci)
                        script_path = "/home/opc/myssh.sh"
                        agent = false
                        timeout = "10m"
                }
        
                inline = [
                        "sudo -u root wget https://objectstorage.us-ashburn-1.oraclecloud.com/p/_xNmt7caueWzV10qJ58_A4b0CUH003H9azUUexJBLag/n/idpjujruxnw2/b/vmdk/o/rhel-server-6.10-x86_64-dvd.iso",
                        "sudo -u root mount -o loop rhel-server-6.10-x86_64-dvd.iso /mnt",
                        "sudo -u root yum install /mnt/Packages/iscsi-initiator-utils-6.2.0.873-27.el6_9.x86_64.rpm"
                        ]
        } 
}