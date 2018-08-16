#!/bin/bash

# your requesting (or Main) vpc
REQUEST_VPC=vpc-4exampleXX
REQUEST_REGION=us-east-1
REQUEST_ROUTES=$(aws ec2 describe-route-tables --query RouteTables[].RouteTableId --filters Name=vpc-id,Values=${REQUEST_VPC} --region ${REQUEST_REGION})

# the accepting (or peer) vpc
ACCEPT_VPC=vpc-0exampleXX12xxx9c
ACCEPT_REGION=us-west-2
ACCEPT_ROUTES=$(aws ec2 describe-route-tables --query RouteTables[].RouteTableId --filters Name=vpc-id,Values=${ACCEPT_VPC} --region ${ACCEPT_REGION})

cat > varfile.$$.tfvars <<_END

request_region = "${REQUEST_REGION}"
request_vpc = "${REQUEST_VPC}"

request_routes = ${REQUEST_ROUTES}

accept_region = "${ACCEPT_REGION}"
accept_vpc = "${ACCEPT_VPC}"

accept_routes = ${ACCEPT_ROUTES}

_END

echo terraform plan -var-file=varfile.$$.tfvars
