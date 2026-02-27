resource "aws_iam_role" "new_role" {
  name = "new_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

}

resource "aws_iam_role_policy_attachment" "new_role_attachment" {
    for_each = toset(var.policy_arns)
    role = aws_iam_role.new_role.name
    policy_arn = each.value
}

resource "aws_iam_instance_profile" "new_instance_profile" {
  name = "new_instance_profile"
  role = aws_iam_role.new_role.name
}