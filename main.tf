data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "nodes_sg" {
  name        = "nodes-sg"
  description = "Allow inbound TCP 22 and 9651"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9651
    to_port     = 9651
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file(var.terraform_ssh_key)
}

resource "aws_instance" "node" {
  count                  = var.node_count
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.deployer.key_name
  subnet_id              = tolist(data.aws_subnet_ids.default.ids)[0]
  vpc_security_group_ids = [aws_security_group.nodes_sg.id]

  root_block_device {
    volume_size = var.disk_size
    volume_type = var.disk_class
  }

  tags = {
    Name = "coqnet${count.index + 1}"
  }
}

resource "aws_eip" "node_eip" {
  count    = var.node_count
  instance = aws_instance.node[count.index].id
  vpc      = true
}

resource "cloudflare_record" "node_dns" {
  count   = var.node_count
  zone_id = var.zone_id
  name    = "coqnet${count.index + 1}.l1launcher.com"
  content = aws_eip.node_eip[count.index].public_ip
  type    = "A"
  ttl     = 300
}
