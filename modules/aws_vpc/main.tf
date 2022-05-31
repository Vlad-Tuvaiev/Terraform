#-------------------------------------------------------------------------------
# - Create security group
# - Create vpc
# - Create 3 type of subnets (private, public, db)
# - Create nat gateaway for private
# - Create internet gateaway for publick
#-------------------------------------------------------------------------------
data "aws_availability_zones" "availabel" {}
#-------------------------------------------------------------------------------
resource "aws_security_group" "SG" {
  name        = "${lower(var.name)}-sg-${lower(var.env)}"
  description = "${var.env}-SG"
  vpc_id      = aws_vpc.main.id
  dynamic "ingress" {
    for_each = lookup(var.allow_port_list, var.env)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name          = "${lower(var.name)}-sg-${lower(var.env)}"
    Environment   = "${var.env}"
    Orchestration = "${var.orchestration}"
    Createdby     = "${var.createdby}"
  }
}
#-------------------------------------------------------------------------------
resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = data.aws_availability_zones.availabel.names[count.index]
  map_public_ip_on_launch = true
  tags = {
    Name          = "${lower(var.name)}-public${count.index + 1}-${lower(var.env)}"
    Environment   = "${var.env}"
    Orchestration = "${var.orchestration}"
    Createdby     = "${var.createdby}"
  }
}
resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name          = "${lower(var.name)}-public-${lower(var.env)}"
    Environment   = "${var.env}"
    Orchestration = "${var.orchestration}"
    Createdby     = "${var.createdby}"
  }
}
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public_subnets[*].id)
  route_table_id = aws_route_table.public_subnets.id
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
}
#-------------------------------------------------------------------------------
resource "aws_eip" "nat" {
  count = length(var.private_subnets_cidr)
  vpc   = true
  tags = {
    Name          = "${lower(var.name)}-nat-gw${count.index + 1}-${lower(var.env)}"
    Environment   = "${var.env}"
    Orchestration = "${var.orchestration}"
    Createdby     = "${var.createdby}"
  }
}
resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnets_cidr)
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = element(aws_subnet.public_subnets[*].id, count.index)
  tags = {
    Name          = "${lower(var.name)}-nat-gw${count.index + 1}-${lower(var.env)}"
    Environment   = "${var.env}"
    Orchestration = "${var.orchestration}"
    Createdby     = "${var.createdby}"
  }
}
resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets_cidr)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.private_subnets_cidr, count.index)
  availability_zone = data.aws_availability_zones.availabel.names[count.index]
  tags = {
    Name          = "${lower(var.name)}-private${count.index + 1}-${lower(var.env)}"
    Environment   = "${var.env}"
    Orchestration = "${var.orchestration}"
    Createdby     = "${var.createdby}"
  }
}
resource "aws_route_table" "private_subnets" {
  count  = length(var.private_subnets_cidr)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat[count.index].id
  }
  tags = {
    Name          = "${lower(var.name)}-private-${count.index + 1}-${lower(var.env)}"
    Environment   = "${var.env}"
    Orchestration = "${var.orchestration}"
    Createdby     = "${var.createdby}"
  }
}
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private_subnets[*].id)
  route_table_id = aws_route_table.private_subnets[count.index].id
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
}
#-------------------------------------------------------------------------------
resource "aws_subnet" "db_subnets" {
  count                   = length(var.db_subnets_cidr)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(var.db_subnets_cidr, count.index)
  availability_zone       = data.aws_availability_zones.availabel.names[count.index]
  map_public_ip_on_launch = false
  tags = {
    Name          = "${lower(var.name)}-db${count.index + 1}-${lower(var.env)}"
    Environment   = "${var.env}"
    Orchestration = "${var.orchestration}"
    Createdby     = "${var.createdby}"
  }
}
resource "aws_route_table" "db_subnets" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name          = "${lower(var.name)}-db-${lower(var.env)}"
    Environment   = "${var.env}"
    Orchestration = "${var.orchestration}"
    Createdby     = "${var.createdby}"
  }
}
resource "aws_route_table_association" "db" {
  count          = length(aws_subnet.db_subnets[*].id)
  route_table_id = aws_route_table.db_subnets.id
  subnet_id      = element(aws_subnet.db_subnets[*].id, count.index)
}
#-------------------------------------------------------------------------------
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name          = "${lower(var.name)}-igw-${lower(var.env)}"
    Environment   = "${var.env}"
    Orchestration = "${var.orchestration}"
    Createdby     = "${var.createdby}"
  }
}
#-------------------------------------------------------------------------------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name          = "${lower(var.name)}-vpc-${lower(var.env)}"
    Environment   = "${var.env}"
    Orchestration = "${var.orchestration}"
    Createdby     = "${var.createdby}"
  }
}
