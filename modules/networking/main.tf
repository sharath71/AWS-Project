resource "aws_vpc" "vpc1"{
	cidr_block = var.vpc_cidr
	instance_tenancy = "default"
	tags = var.vpc_tags
	
}

# Create Internet_Gateway

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.vpc1.id
}


# Create Route Table For Public_subnets

resource "aws_route_table" "public1" { 
   vpc_id = aws_vpc.vpc1.id
   route {
     cidr_block = "0.0.0.0/0"
     gateway_id = aws_internet_gateway.igw1.id
} 
}
############# Public_Subnets   #########
resource "aws_subnet" "subnets1" { 
   count = var.subnet_count
   vpc_id = aws_vpc.vpc1.id
   cidr_block = var.pub_cidrs[count.index]
       }
##############  Associate Public Subnets with Public Route Table ###################

resource "aws_route_table_association" "rpub" { 
   count = var.subnet_count
   subnet_id = aws_subnet.subnets1.*.id[count.index]
   route_table_id = aws_route_table.public1.id
}



