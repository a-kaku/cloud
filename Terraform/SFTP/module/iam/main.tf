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

resource "aws_iam_policy" "custom" {
  for_each = { for k, v in var.iam_policies : k => v if can(v.policy) }

  name   = each.value.name
  policy = each.value.policy
}

resource "aws_iam_role_policy_attachment" "attach" {
  for_each = {
    for k, v in var.iam_policies :
    k => (
      can(v.policy) ? aws_iam_policy.custom[k].arn : v
    )
  }

  role       = aws_iam_role.role.name
  policy_arn = each.value
}