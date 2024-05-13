resource "aws_key_pair" "terraform-key" {
    key_name = "terraform-key"
    public_key = file("${path.module}/terraform-key.pub")
}

resource "aws_security_group" "my-security-group" {
    name        = "terraform-security-group"
    description = "Allow inbound traffic"

    dynamic "ingress" {
        for_each = [22,80,3000, 8080]
        iterator = port
        content {
            from_port   = port.value
            to_port     = port.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
      
    }
    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}

resource "aws_instance" "my-instance" {
  ami           = "ami-08012c0a9ee8e21c4"
  instance_type = "t2.micro"
  tags = {
    Name = "terraform-instance"
  }
  key_name = "${aws_key_pair.terraform-key.key_name}"
  security_groups = [aws_security_group.my-security-group.name]
}