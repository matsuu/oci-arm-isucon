variable "tenancy_ocid" {
}

variable "user_ocid" {
}

variable "fingerprint" {
}

variable "private_key_path" {
}

variable "region" {
}

variable "ssh_authorized_keys" {
}

variable "description" {
  default = "isucon11 qualify"
}

variable "name" {
  default = "isucon11q"
}

variable "shape_ocpus" {
  default = {
    webapp = 2
  }
}

variable "shape_memories" {
  default = {
    webapp = 4
  }
}

variable "num_instances" {
  default = {
    webapp = 1
  }
}

variable "instance_shape" {
  default = "VM.Standard.A1.Flex"
}

variable "source_cidr" {
  default = "0.0.0.0/0"
}
