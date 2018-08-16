provider "aws" {
  alias  = "request"
  region = "${var.request_region}"
}

provider "aws" {
  alias  = "accept"
  region = "${var.accept_region}"
}

data "aws_vpc" "request" {
  provider = "aws.request"
  id       = "${var.request_vpc}"
}

data "aws_vpc" "accept" {
  provider = "aws.accept"
  id       = "${var.accept_vpc}"
}

data "aws_caller_identity" "accept" {
  provider = "aws.accept"
}

# Requester's side of the connection.
resource "aws_vpc_peering_connection" "request" {
  provider      = "aws.request"
  vpc_id        = "${data.aws_vpc.request.id}"
  peer_vpc_id   = "${data.aws_vpc.accept.id}"
  peer_owner_id = "${data.aws_caller_identity.accept.account_id}"
  peer_region   = "${var.accept_region}"
  auto_accept   = false

  tags {
    Side      = "Requester"
    Terraform = "True"
  }
}

# Accepter's side of the connection.
resource "aws_vpc_peering_connection_accepter" "accept" {
  provider                  = "aws.accept"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.request.id}"
  auto_accept               = true

  tags {
    Side      = "Accepter"
    Terraform = "True"
  }
}

# add route to every requesting route table
resource "aws_route" "requesting" {
  provider       = "aws.request"
  count          = "${length(var.request_routes)}"
  route_table_id = "${element(var.request_routes, count.index)}"

  vpc_peering_connection_id = "${aws_vpc_peering_connection.request.id}"
  destination_cidr_block    = "${data.aws_vpc.accept.cidr_block}"
}

# add route to every accepting route table
resource "aws_route" "accepting" {
  provider       = "aws.accept"
  count          = "${length(var.accept_routes)}"
  route_table_id = "${element(var.accept_routes, count.index)}"

  vpc_peering_connection_id = "${aws_vpc_peering_connection_accepter.accept.id}"
  destination_cidr_block    = "${data.aws_vpc.request.cidr_block}"
}
