module "privatevc" {
  source         = "git::https://github.com/berchev/terraform_private_vagrant_cloud.git"
  region         = "${var.region}"
  ami            = "${var.ami}"
  aws_access_key = "${var.aws_access_key}"
  aws_secret_key = "${var.aws_secret_key}"
  instance_type  = "${var.instance_type}"
  key_name       = "${var.key_name}"
  private_key    = "${var.private_key}"
}
