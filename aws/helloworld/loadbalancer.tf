# Create a new load balancer
resource "aws_elb" "public" {
  name = "helloworld-elb"
  subnets = ["${aws_subnet.public1.id}","${aws_subnet.public2.id}"]

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  //  listener {
  //    instance_port = 80
  //    instance_protocol = "http"
  //    lb_port = 443
  //    lb_protocol = "https"
  //    ssl_certificate_id = "${var.cert_name}"
  //  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 2
    timeout = 3
    target = "HTTP:8080/"
    interval = 30
  }

  instances = ["${aws_instance.helloworld_server.id}"]
  security_groups = ["${aws_security_group.public_http_access.id}"]
  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  tags {
    Name = "Main ELB"
  }
}