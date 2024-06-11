#!/usr/bin/env python
"""Django's command-line utility for administrative tasks."""
import os
import sys

import time
from django.db import connections
from django.db.utils import OperationalError

def check_db_connection():
    """Verifica a disponibilidade do banco de dados"""
    db_conn = None
    max_tries = 10
    tries = 0
    while not db_conn and tries < max_tries:
        try:
            db_conn = connections['default']
            print("Database is available.")
        except OperationalError:
            tries += 1
            print(f"Database unavailable, waiting 5 seconds... ({tries}/{max_tries})")
            time.sleep(5)
    if not db_conn:
        print("Failed to connect to the database after several attempts.")
        sys.exit(1)

def main():
    """Run administrative tasks."""
    os.environ.setdefault("DJANGO_SETTINGS_MODULE", "bookstore.settings")
    try:
        from django.core.management import execute_from_command_line
    except ImportError as exc:
        raise ImportError(
            "Couldn't import Django. Are you sure it's installed and "
            "available on your PYTHONPATH environment variable? Did you "
            "forget to activate a virtual environment?"
        ) from exc

    # Checar se estamos executando o comando wait_for_db
    if len(sys.argv) > 1 and sys.argv[1] == "wait_for_db":
        check_db_connection()
    else:
        execute_from_command_line(sys.argv)

if __name__ == "__main__":
    main()


