# ec2 
resource "aws_instance" "terra-ec2" {
  ami                     = "ami-0b08bfc6ff7069aff"
  instance_type           = "t2.micro"
  subnet_id = aws_subnet.terra-sub-a.id
  key_name = "hyd"
  vpc_security_group_ids = [aws_security_group.terra-ssh-http.id]
  user_data = file("services.sh")

  tags = {
    Name = "terra.ec2"
  }
}