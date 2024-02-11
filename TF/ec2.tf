resource "aws_instance" "tf_instance" {
  ami           = "ami-0e731c8a588258d0d" # Amazon Linux 2023
  instance_type = "t2.micro"
  key_name      = "aws_key" # By default, user is admin, ec2-user or similar.
  vpc_security_group_ids = [
    aws_security_group.sg_ssh.id,
    aws_security_group.sg_https.id,
    aws_security_group.sg_http.id,
    aws_security_group.sg_mysql.id
  ]
  #user_data = "${file("user_data.sh")}"
  user_data = <<-EOF
    #!/bin/bash
    echo user_data inlined script begints execution
    sudo dnf update -y
    sudo dnf install -y mariadb105
    echo "mysql -u ${var.db_admin} -p'${var.db_password}' -h '${element(split(":", aws_db_instance.default.endpoint), 0)}' -P 3306" > /root/mysql-command.txt
  EOF
  tags = {
    Name = "TF-triggered-instance"
  }
}