provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

resource "aws_security_group" "security_group" {
  name = "network"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Creating AWS EC2 instance
resource "aws_instance" "server" {
  ami                         = "${var.ami}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  associate_public_ip_address = "true"
  vpc_security_group_ids      = ["${aws_security_group.instance.id}"]
}

# take public dns of newly created server and add it to JSON
data "template_file" "json" {
  template = "${file("${path.module}/conf/precise64.json")}"

  vars = {
    dns = "${aws_instance.server.public_dns}"
  }
}

# we use null_resource as we will be grabing information from the just created
# instance like hotstname. And use that name to configure nginx

# add template content JSON as a file to target server 
resource "null_resource" "add_json" {
  connection {
    host = "${aws_instance.server.public_ip}"
  }

  provisioner "file" {
    content     = "${data.template_file.json.rendered}"
    destination = "/tmp/precise64.json"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("${var.private_key}")}"
    }
  }
}

# take public dns of newly created server and add it to nginx.conf
data "template_file" "nginx" {
  template = "${file("${path.module}/conf/nginx.conf")}"

  vars = {
    dns = "${aws_instance.server.public_dns}"
  }
}

# add template content JSON as a file to target webserver 
resource "null_resource" "add_nginx" {
  connection {
    host = "${aws_instance.server.public_ip}"
  }

  provisioner "file" {
    content     = "${data.template_file.nginx.rendered}"
    destination = "/tmp/nginx.conf"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("${var.private_key}")}"
    }
  }
}

# Add both boxes to the server
resource "null_resource" "add_assets" {
  connection {
    host = "${aws_instance.server.public_ip}"
  }

  provisioner "file" {
    source      = "assets"
    destination = "/tmp"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("${var.private_key}")}"
    }
  }
}

# Copy all needed configuration to newly created EC2 instance
resource "null_resource" "add_provision_script" {
  connection {
    host = "${aws_instance.server.public_ip}"
  }

  provisioner "file" {
    source      = "${path.module}/scripts/provision.sh"
    destination = "/tmp/provision.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("${var.private_key}")}"
    }
  }
}

# Executing provision script
# Do not forget to add on depends_on section "null_resource.add_assets" !!!!
resource "null_resource" "execute_provision_script" {
  depends_on = ["null_resource.add_json", "null_resource.add_nginx", "null_resource.add_provision_script", "null_resource.add_assets"]

  connection {
    host = "${aws_instance.server.public_ip}"
  }

  provisioner "remote-exec" {
    inline = [
      "cd /tmp",
      "sudo bash ./provision.sh",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file("${var.private_key}")}"
    }
  }
}
