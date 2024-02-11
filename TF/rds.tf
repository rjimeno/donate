resource "aws_db_instance" "default" {
  identifier             = "rds-database"
  allocated_storage      = 10
  storage_type           = "gp2" # "gp3" if more IOPS or size is needed.
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t3.micro"
  username               = var.db_admin
  password               = var.db_password
  port                   = var.db_port
  vpc_security_group_ids = [aws_security_group.sg_mysql.id]
  skip_final_snapshot    = true // required to destroy
}