resource "aws_lb" "new_nlb" {
  name               = var.nlb_name
  internal           = false
  load_balancer_type = "network"
  security_groups    = [data.aws_security_group.nlb_sg.id]

  dynamic "subnet_mapping" {
    for_each = var.nlb_config

    content {
      subnet_id     = data.aws_subnet.this[subnet_mapping.key].id
      allocation_id = subnet_mapping.value.allocation_id
    }
  }

  tags = {
    Name = var.nlb_name
    CmBillingGroup = var.CmBillingGroup
  }
}

data "aws_subnet" "this" {
  for_each = var.nlb_config

  filter {
    name   = "tag:Name"
    values = [each.value.subnet_name]
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
  for_each = var.target_instance_ids
  
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id        = each.value
  port             = 22
}

data "aws_security_group" "nlb_sg" {
  filter {
    name   = "tag:Name"
    values = [var.nlb_sg_name]
  }
}