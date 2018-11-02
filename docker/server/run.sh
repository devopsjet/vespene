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

if [[ "${GENERATE_SECRET,,}" == 'true' ]]; then
  echo 'Generating secret...'
  python3 manage.py generate_secret
fi

if [[ "${RUN_MIGRATIONS,,}" == 'true' ]]; then
  echo "Running DB migrations..."
  python3 manage.py migrate
fi

if [[ "${CREATE_SUPERUSER,,}" == 'true' ]]; then
  echo "Creating superuser..."
  python3 manage.py createsuperuser
fi

gunicorn "$@" vespene.wsgi