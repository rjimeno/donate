import os  # For os.environm('TF_VAR_)
import mysql.connector

import click
from flask import current_app, g

def get_mydb():
    if 'db' not in g:
        # All the values here should be obtained from the environment,
        # configuration files, build-time or dynamically as needed.
        g.db = mysql.connector.connect(
            database='donate',
            host="<RDS_DATABASE_HOST_NAME>",
            user="db_admin",
            password=os.environ['TF_VAR_db_password']
        )

    return g.db

def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()

def init_mydb():
    db = get_mydb()
    mycursor = db.cursor()

    with current_app.open_resource('schema.sql') as f:
        mycursor.execute(f.read().decode('utf8'), multi=True)
    f.close()

def init_app(app):
    app.teardown_appcontext(close_db)
    app.cli.add_command(init_db_command)

@click.command('init-db')
def init_db_command():
    """Clear the existing data and create new tables."""
    #init_db()
    init_mydb()
    click.echo('Initialized the database.')