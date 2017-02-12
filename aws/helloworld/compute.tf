resource "aws_instance" "helloworld_server" {
  tags {
    Name = "HelloWorld Server"
  }
  key_name      = "${lookup(var.key_name, var.aws_region)}"
  ami           = "${lookup(var.aws_amis, var.aws_region)}"
  instance_type = "t2.micro"
  subnet_id     = "${aws_subnet.private1.id}"
  security_groups = ["${aws_security_group.private_http_access.id}", "${aws_security_group.private_ssh.id}"]
}