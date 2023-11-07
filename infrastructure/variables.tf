variable "Type" {
  description = "Node types: EC2 instance types to use for different nodes"
  type = string
  default = "t3a.medium"
}

variable "Zone" {
  type = string
  description = "Existing DNS zone to put openshift cluster in"
  default = "heinlein-akademie-openshift.de"
}

variable "Teilnehmer" {
  type = number
  description = "Anzahl der Teilnehmer"
  default = 3
}
