resource "aws_iam_user" "user" {
  count = var.Teilnehmer
  name = "teilnehmer-${count.index}"
  path = "/system/"
}


resource "aws_iam_access_key" "access-key" {
  count = var.Teilnehmer
  user = element(aws_iam_user.user, count.index).name
}

resource "aws_iam_user_policy" "lb_ro" {
  name = "training-user-${count.index}-policy"
  user = element(aws_iam_user.user, count.index).name
  count = var.Teilnehmer

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}