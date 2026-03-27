resource "aws_route53_record" "new_record" {
    zone_id = data.aws_route53_zone.hosted_zone.zone_id
    name = var.domain_name
    type = var.record_type
    records = [var.record]
}

data "aws_route53_zone" "hosted_zone" {
    name = var.hosted_zone_name
}