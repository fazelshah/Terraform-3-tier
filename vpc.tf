resource "aws_vpc" "bqe" {
    cidr_block = var.cidr_block
    tags = {
      "Name" = "BQE-VPC"
    }
  
}

resource "aws_subnet" "pub" {
    vpc_id = aws_vpc.bqe.id
    cidr_block = "10.0.1.0/24"
    tags = {
      "Name" = "Pub-Sub"
    }
  
}
resource "aws_subnet" "pvt" {
    vpc_id = aws_vpc.bqe.id
    cidr_block = "10.0.2.0/24"
    tags = {
      "Name" = "Pvt-Sub"
    }
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.bqe.id
  tags = {

    Name = "IGW"
  }  
}

resource "aws_route_table" "RT1" {
    vpc_id = aws_vpc.bqe.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
    }
  
resource "aws_route_table" "RT2" {
    vpc_id = aws_vpc.bqe.id

    
    }
    resource "aws_route_table_association" "RTA1" {
        subnet_id = aws_subnet.pub.id
        route_table_id = aws_route_table.RT1.id
      
    }

    resource "aws_route_table_association" "RTA2" {
        subnet_id = aws_subnet.pvt.id
        route_table_id = aws_route_table.RT2.id
      
    }
    resource "aws_eip" "NAT" {
      
    }
    resource "aws_nat_gateway" "NAT" {
        allocation_id = aws_eip.NAT.id
        subnet_id = aws_subnet.pub.id

        tags = {
          Name = "NAT"
        }
      
    }

resource "aws_route" "R_NAT" {
    route_table_id = aws_route_table.RT2
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.NAT.id
  
}