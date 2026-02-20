resource "aws_iam_role" "role" {
    name = var.iam_role_name

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ec2.amazonaws.com"
                }
            }
        ]
    })

    tags = {
        Name = var.iam_role_name
        CmBillingGroup = var.CmBillingGroup
    }
}

resource "aws_iam_role_policy_attachment" "attach" {
  for_each = var.iam_policies

  role       = aws_iam_role.role.name
  policy_arn = each.value.policy
}