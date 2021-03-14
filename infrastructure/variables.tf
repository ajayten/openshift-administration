variable "Type" {
  description = "Node types: EC2 instance types to use for different nodes"
  type = string
  default = "t3a.medium"
}

variable "Zone" {
  type = string
  description = "Existing DNS zone to put openshift cluster in"
  default = "cc-openshift.de"
}

variable "Teilnehmer" {
  type = string
  description = "Anzahl der Teilnehmer"
}