resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_internet_gateway" "default" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_eip" "nat" {
  vpc      = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat.id}"
  subnet_id = "${aws_subnet.public1.id}"
  depends_on = ["aws_internet_gateway.default"]
}


resource "aws_route_table" "main" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }
  tags {
    Name = "main"
  }
}

resource "aws_route_table" "nat" {
  vpc_id = "${aws_vpc.default.id}"
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw.id}"
  }
  tags {
    Name = "NAT"
  }
}

resource "aws_route_table_association" "nat_association" {
  route_table_id = "${aws_route_table.nat.id}"
  subnet_id = "${aws_subnet.private1.id}"
}

resource "aws_main_route_table_association" "main_association" {

  route_table_id = "${aws_route_table.main.id}"
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_subnet" "private1" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone = "${element(split(",",lookup(var.availability_zones, var.aws_region)),0)}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "private2" {
  vpc_id                  = "${aws_vpc.default.id}"
  availability_zone = "${element(split(",",lookup(var.availability_zones, var.aws_region)),1)}"
  cidr_block              = "10.0.3.0/24"
  map_public_ip_on_launch = false
}

resource "aws_subnet" "public1" {
  vpc_id      = "${aws_vpc.default.id}"
  availability_zone = "${element(split(",",lookup(var.availability_zones, var.aws_region)),0)}"
  cidr_block  = "10.0.2.0/24"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public2" {
  vpc_id      = "${aws_vpc.default.id}"
  availability_zone = "${element(split(",",lookup(var.availability_zones, var.aws_region)),1)}"
  cidr_block  = "10.0.4.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "public_ssh" {
  name = "ssh access"
  description = "ssh security group to allow access from anywhere over ssh to port 22"
  vpc_id      = "${aws_vpc.default.id}"


  # SSH access from anywhere
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_ssh" {
  name = "internal ssh access"
  description = "ssh security group to allow access from our subnets only over ssh to port 22"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "private_mysql" {
  name = "internal access to mysql DB"
  description = "Allow access over port 3306 to mysql db"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port = 3306
    to_port = 3306
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "public_http_access" {
  name = "public http access"
  description = "Allows traffic on 80 and 443 from anywhere"
  vpc_id      = "${aws_vpc.default.id}"


  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "private_http_access" {
  name = "private http access"
  description = "only traffic through on http that has originated in the vpc"
  vpc_id      = "${aws_vpc.default.id}"

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}