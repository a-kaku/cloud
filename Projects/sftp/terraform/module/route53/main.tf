resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.domain_name
  type    = var.type
  ttl     = 300
  records = [var.record]
}

data "aws_route53_zone" "hosted_zone" {
    name = var.hosted_zone_name
}