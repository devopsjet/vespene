FROM ubuntu:18.04

# install Python and upgrade pip
RUN apt-get update \
 && apt-get install -y \
  gcc libssl-dev postgresql-client python3 python3-pip python3-setuptools supervisor \
 && apt-get -y clean && rm -rf /var/lib/apt/lists/* \
 && pip3 install --upgrade pip

# create dirs and add the app
RUN mkdir -p /var/spool/vespene /etc/vespene/settings.d/ /var/log/vespene/
COPY . /opt/vespene/
RUN mv /opt/vespene/docker/server/run.sh / && chmod +x /run.sh

RUN python3 -m pip install -r /opt/vespene/requirements.txt --trusted-host pypi.org --trusted-host files.pypi.org --trusted-host files.pythonhosted.org

# Variables and final setup
WORKDIR /opt/vespene

ENV DB_SERVER="db"
ENV DB_USER="vespene"
ENV DB_NAME="vespene"
ENV DB_PASSWORD="vespene!"

ENV BUILDROOT="/tmp/vespene"

ENV GENERATE_SECRET="true"
ENV CREATE_SUPERUSER="false"
ENV RUN_MIGRATIONS="true"

ENTRYPOINT ["/run.sh"]
# gunicorn options
CMD ["--bind", "0.0.0.0:8000"]