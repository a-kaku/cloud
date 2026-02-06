resource "aws_lb" "new_nlb" {
  name               = var.nlb_name
  internal           = false
  load_balancer_type = "network"

  dynamic "subnet_mapping" {
    for_each = var.eip_allocation_ids

    content {
    subnet_id      = subnet_mapping.key
    allocation_id = subnet_mapping.value
    }
  }

  tags = {
    Name = var.nlb_name
    CmBillingGroup = var.CmBillingGroup
  }
}

data "aws_subnets" "subnet_a" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_a_name]
  }
}

data "aws_subnets" "subnet_d" {
  filter {
    name   = "tag:Name"
    values = [var.subnet_d_name]
  }
}

resource "aws_lb_listener" "hgs_nlb_listener" {
  load_balancer_arn = aws_lb.new_nlb.arn
  port              = 22
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nlb_tg.arn
  }
}

resource "aws_lb_target_group" "nlb_tg" {
  name     = var.nlb_tg_tag_name
  port     = 22
  protocol = "TCP"
  target_type = "instance"
  vpc_id = var.vpc_id

  tags = {
    Name = var.nlb_tg_tag_name
  }
}

resource "aws_lb_target_group_attachment" "sftp_attachment" {
  for_each = module.sftp_instance.instance_ids
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = each.value
  port             = 22
}
