resource "aws_lb" "hgs_nlb" {
  name               = "hgs-nlb"
  internal           = false
  load_balancer_type = "network"
subnets = concat(
  data.aws_subnets.h21pulic_a.ids,
  data.aws_subnets.h21pulic_d.ids
)
  tags = {
    Name = "hgs-nlb"
  }
}

data "aws_subnets" "h21pulic_a" {
  filter {
    name   = "tag:Name"
    values = ["h21public-a"]
  }
}

data "aws_subnets" "h21pulic_d" {
  filter {
    name   = "tag:Name"
    values = ["h21public-d"]
  }
}

resource "aws_lb_listener" "hgs_nlb_listener" {
  load_balancer_arn = aws_lb.hgs_nlb.arn
  port              = 2222
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.hgs_nlb_tg01.arn
  }
}

resource "aws_lb_target_group" "hgs_nlb_tg01" {
  name     = "hgs-nlb-tg01"
  port     = 22
  protocol = "TCP"
  target_type = "instance"
  vpc_id = "vpc-66901d03"

  tags = {
    Name = "hgs-nlb-tg"
  }
}

resource "aws_lb_target_group_attachment" "sftp_tmp01_attachment" {
  target_group_arn = aws_lb_target_group.hgs_nlb_tg01.arn
  target_id        = aws_instance.sftp_tmp01.id
  port             = 22
}

resource "aws_lb_target_group" "hgs_nlb_tg02" {
  name     = "hgs-nlb-tg02"
  port     = 22
  protocol = "TCP"
  target_type = "instance"
  vpc_id = "vpc-66901d03"

  tags = {
    Name = "hgs-nlb-tg"
  }
}

resource "aws_lb_target_group_attachment" "sftp_tmp02_attachment" {
  target_group_arn = aws_lb_target_group.hgs_nlb_tg02.arn
  target_id        = aws_instance.sftp_tmp02.id
  port             = 22
}
