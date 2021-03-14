resource "aws_instance" "machine" {
  depends_on             = [aws_internet_gateway.igw]

  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.Type
  key_name               = "training-${count.index}"

  subnet_id              = aws_subnet.subnet-public.id

  user_data              = format("%s%s", file("init.sh"), <<EOF

  echo "aws_access_key_id = ${element(aws_iam_access_key.access-key, count.index).id}" >> /home/ubuntu/.aws/credentials
  echo "aws_secret_access_key = ${element(aws_iam_access_key.access-key, count.index).secret}" >> /home/ubuntu/.aws/credentials
  reboot

  EOF
  )

  vpc_security_group_ids = [aws_security_group.machine-sg.id]
  ebs_optimized = true

  count = var.Teilnehmer

  root_block_device {
    volume_type = "gp3"
    volume_size = 25
  }

  tags = {
    Name = "Heinlein Training Machine ${count.index}"
  }
}

resource "aws_security_group" "machine-sg" {
  description = "Heinlein Training Security Group for Machine"
  name        = "training-machine-sg"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port        = "-1"
    to_port          = "-1"
    protocol         = "icmp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Heinlein Training Security Group for Machine"
  }
}

resource "aws_route53_record" "machine-records" {
  zone_id = data.aws_route53_zone.existing-zone.zone_id
  name    = "training${count.index}.${data.aws_route53_zone.existing-zone.name}"
  type = "CNAME"

  count = var.Teilnehmer

  ttl = "300"
  records = [element(aws_instance.machine, count.index).public_dns]
}