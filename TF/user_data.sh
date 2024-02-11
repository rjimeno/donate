#!/bin/bash
echo user_data inlined script begints execution
sudo dnf update -y
sudo dnf install mariadb105-server
echo "mysql -u ${var.db_admin} -p'${var.db_password}' -h ${element(split(":", aws_db_instance.default.endpoint), 0)} -P 3306" > user_data.out
