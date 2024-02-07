When you run `terraform apply`, you will need to type the
password for the db_admin user of the database. Alternatively,
set or export the TF_VAR_db_password environment variable before
invoking `terraform apply` so you don't get prompted for the
password.

If you use `TF_VAR_db_password` avoid getting the value in your
shell's history by prepending a space (or equivalent trick in your
shell of choice).