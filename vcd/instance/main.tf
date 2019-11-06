resource "vcd_vapp" "vApp" {
  name = "${var.name}"
  power_on = "false"
}

resource "vcd_vapp_vm" "instance" {
  vapp_name = "${var.name}"
  count = "${var.quantity}"
  name = "${var.name}-${count.index}"
  catalog_name  = "${var.catalog}"
  template_name = "${data.external.image_sync.result.template_name}"
  memory = "${var.memory}"
  cpus = "${var.cpus}"
  depends_on = ["vcd_vapp.vApp","data.external.image_sync","null_resource.postdestroy"]
  power_on = "false"

  network {
    type = "org"
    name = "${var.network_name}"
    ip_allocation_mode = "DHCP"
    is_primary         = true
  }

  lifecycle {
    ignore_changes = ["*"]
  }
}

resource "vcd_inserted_media" "ISO" {
  count = "${var.quantity}"
  catalog = "${var.catalog}"
  name = "${var.name}-${count.index}-user-data.iso"
  vapp_name = "${var.name}"
  vm_name = "${var.name}-${count.index}"

  lifecycle {
    ignore_changes = ["*"]
  }

  depends_on = ["vcd_vapp_vm.instance","null_resource.iso_upload"]
}

data "template_file" "meta-data" {
  count = "${var.quantity}"
  template = "${file("${path.module}/meta-data.tmpl")}"
  vars = {
    name = "${var.name}"
    hostname = "${var.name}-${count.index}"
    keypair = "${var.keypair}"
  }
}

resource "null_resource" "cloud_init_iso" {
  count = "${var.quantity}"
  depends_on = ["data.template_file.meta-data"]
  provisioner "local-exec" {
    command = <<EOF
mkdir ${path.module}/${var.name}-${count.index}-iso
cat <<'EOS' > ${path.module}/${var.name}-${count.index}-iso/user-data
${element(var.userdata,count.index)}
EOS
cat <<'EOS' > ${path.module}/${var.name}-${count.index}-iso/meta-data
${data.template_file.meta-data.*.rendered[count.index]}
EOS
genisoimage -output ${path.module}/${var.name}-${count.index}-user-data.iso -volid cidata -joliet -rock ${path.module}/${var.name}-${count.index}-iso/user-data ${path.module}/${var.name}-${count.index}-iso/meta-data
rm -rf ${path.module}/${var.name}-${count.index}-iso
EOF
  }
}

resource "null_resource" "iso_upload" {
  count = "${var.quantity}"
  depends_on = ["null_resource.cloud_init_iso"]
  provisioner "local-exec" {
    environment {
      VCD_URL="${var.vcd_url}"
      VCD_USERNAME="${var.vcd_username}"
      VCD_PASSWORD="${var.vcd_password}"
      VCD_ORG="${var.vcd_org}"
      ISO_NAME="${var.name}-${count.index}-user-data.iso"
      CATALOG_NAME="${var.catalog}"
      ISO_PATH="${path.module}/${var.name}-${count.index}-user-data.iso"
    }
    interpreter = ["bash", "-c"]
    command = "bash ${path.module}/iso_upload.sh && sleep 30"
  }
}

resource "null_resource" "power_on" {
  count = "${var.quantity}"
  depends_on = ["vcd_inserted_media.ISO"]

  provisioner "local-exec" {
    environment {
      VCD_URL="${var.vcd_url}"
      VCD_USERNAME="${var.vcd_username}"
      VCD_PASSWORD="${var.vcd_password}"
      VCD_ORG="${var.vcd_org}"
      VAPP_NAME="${var.name}"
      VM="${var.name}-${count.index}"
      ACTION="powerOn"
    }
    interpreter = ["bash", "-c"]
    command = "bash ${path.module}/power_ctl.sh"
  }

  lifecycle {
    ignore_changes = ["*"]
  }
}

data "external" "image_sync" {
  program = [
    "/bin/bash",
    "-c",
    <<EOF
export VCD_URL='${var.vcd_url}'
export VCD_USERNAME='${var.vcd_username}'
export VCD_PASSWORD='${var.vcd_password}'
export VCD_ORG='${var.vcd_org}'
export CATALOG_NAME='${var.catalog}'
export VCD_PASSWORD='${var.vcd_password}'
export TEMPLATE_NAME=${var.template}
export TEMPLATE_URL=https://swift.entercloudsuite.com/v1/KEY_1a68c22a99cd4e558054ede2c878929d/automium-catalog-images/vsphere/${var.template}.ova
bash ${path.module}/image_sync.sh
EOF
  ]
}

output "image_sync_message" {
  value = "${data.external.image_sync.result.output}"
}

resource "null_resource" "postdestroy" {
  count = "${var.quantity}"
  provisioner "local-exec" {
    when = "destroy"
    command = "${var.postdestroy}"
    environment {
      _NUMBER = "${count.index}"
    }
  }
}
