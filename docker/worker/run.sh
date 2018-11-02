#!/bin/bash
# DB setup
tee /etc/vespene/settings.d/database.py >/dev/null <<END_OF_DATABASES
DATABASES = {
        'default': {
            'ENGINE': 'django.db.backends.postgresql',
            'NAME': '${DB_NAME}',
            'USER': '${DB_USER}',
            'PASSWORD' : '${DB_PASSWORD}',
            'HOST': '${DB_SERVER}',
            'ATOMIC_REQUESTS': True
        }
}
END_OF_DATABASES

tee /etc/vespene/settings.d/workers.py >/dev/null << END_OF_WORKERS
BUILD_ROOT="${BUILDROOT}"
# FILESERVING_ENABLED = True
# FILESERVING_PORT = 8000
# FILESERVING_HOSTNAME = "this-server.example.com"
END_OF_WORKERS

POOL="${1:-general}"
/usr/bin/ssh-agent /usr/bin/python3 manage.py worker "${POOL}"