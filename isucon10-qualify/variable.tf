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
  default = "isucon10 qualify"
}

variable "name" {
  default = "isucon10q"
}

variable "shape_ocpus" {
  default = {
    bench      = 1
    competitor = 1
  }
}

variable "shape_memories" {
  default = {
    bench      = 16
    competitor = 2
  }
}

variable "num_instances" {
  default = {
    bench      = 1
    competitor = 3
  }
}

variable "instance_shape" {
  default = "VM.Standard.A1.Flex"
}

variable "source_cidr" {
  default = "0.0.0.0/0"
}
