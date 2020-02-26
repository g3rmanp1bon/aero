variable "tenancy_ocid" {

  default = "ocid1.tenancy.oc1..aaaaaaaaafj33u5lrwrulqmtjao3ln3z2bdmnu6lswxjezzhvl6qaq5ndnia"

}
variable "user_ocid" {
  default = "ocid1.user.oc1..aaaaaaaaumyjuonqbne5xhdn5p45uk7jqnyhlfxbpnxgkw7ecqxya2kspo5q"
}
variable "fingerprint" {
  default = "08:0c:0e:bd:61:e3:36:24:b1:a5:b9:7a:de:40:fb:a2"
}
variable "private_key_path" {
  default = "/Users/gpabon/.oci/oci_api_key.pem"
}
variable "compartment_ocid" {
  default = "ocid1.compartment.oc1..aaaaaaaa7j77ynrzkmyypeth6ojmhahyqra7iwmdvsutweqoiocfgtql3v4a"
}
variable "region" {
  default = "us-ashburn-1"
}
variable "private_key_oci" {
  default = "/Users/gpabon/id_rsa"
}
variable "public_key_oci" {
  default = "/Users/gpabon/id_rsa.pub"
}

variable "ADs" {
  default = ["dvEY:US-ASHBURN-AD-1", "dvEY:US-ASHBURN-AD-2", "dvEY:US-ASHBURN-AD-3"]
}

variable "Shapes" {
 default = ["VM.Standard.E2.1","VM.Standard.E2.1.Micro","VM.Standard2.1","VM.Standard.E2.1","VM.Standard.E2.2"]
}

variable "Images" {
 # Oracle-Linux-7.7-2020.02.21-0 in Ashburn [0]
 # Red Hat Enterprise Linux 6.10 in Ashburn [1]
 default = ["ocid1.image.oc1.iad.aaaaaaaavzjw65d6pngbghgrujb76r7zgh2s64bdl4afombrdocn4wdfrwdq",
            "ocid1.image.oc1.iad.aaaaaaaablu35656bvn4grpnmpm4il6anlsnjyptc6apo4svlbu76emvajcq"]
}

variable "imgID" { 
  # Red Hat 6.10 Image
  default = "ocid1.image.oc1.iad.aaaaaaaablu35656bvn4grpnmpm4il6anlsnjyptc6apo4svlbu76emvajcq" 
}

variable "subnet" {
  default = "ocid1.subnet.oc1.iad.aaaaaaaalrn6rnhyaxiifrujlk75b2qhmxccepy263xctd32jqv5dktarexq"
}

