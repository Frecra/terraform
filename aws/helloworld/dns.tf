resource "aws_route53_record" "helloworld" {
  zone_id = "${var.route53_zone}"
  name = "${var.domain_name}"
  type = "CNAME"
  ttl = "300"
  records = ["${aws_elb.public.dns_name}"]
}