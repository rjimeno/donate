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
  user_data = <<-EOF
#!/bin/bash

MYSQL_FILE=$(mktemp mysql.XXXXXXXXXX)

DATABASE_NAME=donate

echo user_data inlined script begints execution

sudo dnf update -y
sudo dnf install -y git  # Useful in the aux node only (or mostly).
sudo dnf install -y mariadb105

echo "CREATE DATABASE $DATABASE_NAME;" > $MYSQL_FILE # Creates the file.
echo "USE $DATABASE_NAME;" >> $MYSQL_FILE
cat <<EOSQL >>$MYSQL_FILE
CREATE TABLE USERS
(
  uID             INT unsigned NOT NULL AUTO_INCREMENT, # Unique ID for the user.
  email           VARCHAR(150) NOT NULL,                # Email address for notifications.
  preferedPayment VARCHAR(150) NOT NULL,                # 
  PRIMARY KEY     (uID)                                  # Make the uID the primary key
);

CREATE TABLE PAYMENTS_TABLE
(
  uID             INT unsigned NOT NULL, # Unique ID for the user matching this payment (form?)
  secret          VARCHAR(150) NOT NULL                # 
);

CREATE TABLE MONEY
(
  uID             INT unsigned NOT NULL,                # Unique ID for the user matching this campaign.
  campaignID      INT unsigned NOT NULL,                # Unique ID for the campaign matching this record
  amount          DECIMAL(13, 4) NOT NULL,              # Amount for this donation
  myGeneratedID   INT unsigned NOT NULL AUTO_INCREMENT, # Unique ID for this donation record.
  processorTransactionID INT unsigned NOT NULL,         # Unique ID for the transaction with this processor.
  processorID     INT unsigned NOT NULL,                # Unique ID for the processor.
  PRIMARY KEY     (myGeneratedID)                       # Make the myGeneratedID the primary key.
);

CREATE TABLE CAMPAIGNS
(
  cID             INT unsigned NOT NULL AUTO_INCREMENT, # Unique ID for the campaign.
  user_owner      INt unsigned NOT NULL,                # Unique ID for the user owning this campaign.
  current_total   DECIMAL(13,4) NOT NULL,               #
  goal_amount     DECIMAL(13, 4) NOT NULL,              # Once this amount is reached, the campaign ends.
  PRIMARY KEY     (cID)                                 # Make the cID the primary key
);

EOSQL

mysql -u ${var.db_admin} -p'${var.db_password}' -h '${element(split(":", aws_db_instance.default.endpoint), 0)}' -P 3306 < $MYSQL_FILE

rm $MYSQL_FILE  # Should not be needed anymore, so it's probably best to delete it.

EOF

  tags = {
    Name = "aux"
  }
}