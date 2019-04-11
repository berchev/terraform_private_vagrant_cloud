output "pulic_dns" {
  value = "${aws_instance.server.public_dns}"
}
