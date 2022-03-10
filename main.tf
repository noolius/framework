terraform {
  required_providers {
    local	= {
      source	= "hashicorp/null"
      version	= "~> 3.1.0"
    }
  }
}

resource "null_resource" "node" {
  provisioner "local-exec" {
    command	= "./to_parll.sh provision"
    working_dir	= "."
  }

  provisioner "local-exec" {
    when	= destroy
    command	= "vagrant destroy -f"
    working_dir	= "."
  }
}
