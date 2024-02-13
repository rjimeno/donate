import os  # For os.environm('TF_VAR_)
import sqlite3
import mysql.connector

import click
from flask import current_app, g


def get_db():
    if 'db' not in g:
        g.db = sqlite3.connect(
            current_app.config['DATABASE'],
            detect_types=sqlite3.PARSE_DECLTYPES
        )
        g.db.row_factory = sqlite3.Row

    return g.db

def get_mydb():
    if 'db' not in g:
        # All the values here should be obtained from the environment,
        # configuration files, build-time or dynamically as needed.
        g.db = mysql.connector.connect(
            host="rds-database.cwugnevba7cv.us-east-1.rds.amazonaws.com",
            user="db_admin",
            password=os.environ['TF_VAR_db_password']
        )

    return g.db

def close_db(e=None):
    db = g.pop('db', None)

    if db is not None:
        db.close()

def init_db():
    db = get_db()

    with current_app.open_resource('schema.sql') as f:
        db.executescript(f.read().decode('utf8'))
    f.close()

def init_mydb():
    db = get_mydb()

    with current_app.open_resource('schema.sql') as f:
        db.executescript(f.read().decode('utf8'))
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

#mycursor.execute("SHOW DATABASES")
#for x in mycursor:
#  print(x)
