data "aws_caller_identity" "current" {}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id
}

resource "null_resource" "install_calico_with_ansible" {
  provisioner "local-exec" {
    command = <<-EOT
      ansible-playbook -i ${path.module}/playbooks/inventory.ini ${path.module}/playbooks/install-calico-playbook.yaml --extra-vars "aws_eks_cluster_name=${var.aws_eks_cluster_name} --extra-vars "region=${var.region} --extra-vars "aws_account_id=${local.aws_account_id}"
    EOT
  }
  triggers = {
    key = uuid()
  }
}
