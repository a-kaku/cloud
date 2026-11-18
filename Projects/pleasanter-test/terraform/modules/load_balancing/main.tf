resource "aws_lb_target_group" "tar_group" {
  name     = var.target_group_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_target_group_attachment" "tg_attach" {
  target_group_arn = aws_lb_target_group.tar_group.arn
  target_id        = var.instance_id
  port             = 80
}

data "aws_lb" "lb" {
  arn  = var.lb_arn
  name = var.lb_name
}

data "aws_lb_listener" "listener_80" {
  arn = var.listener_80_arn
}

data "aws_lb_listener" "listener_443" {
  arn = var.listener_443_arn
}