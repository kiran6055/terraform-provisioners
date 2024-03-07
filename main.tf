resource "aws_instance" "test" {
  ami           = "ami-0ba259e664698cbfc"
  instance_type = "t3.micro"
  security_groups = [aws_security_group.test_provisioners.id]
  key_name      = "terraform1"



  tags = {
    Name = "remote-exec-provisioners"
  }

#this provisioner is running inlocal, local means where ever we are running our terraform command
#  provisioner "local-exec" {
#    command = "echo ${self.private_ip} > ip.txt"
#  }

#this remote-exec provisioner will create the infra and perform the commands inside that infra like ansible here we are installing nginx

  connection {
    type          = "ssh"
    user          = "ec2-user"
    private_key   = file("${path.root}/Downloads/terraform1.pem")
    host          = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo systemctl start nginx",
    ]
  }
}



