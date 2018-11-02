FROM ubuntu:18.04

# install Python and upgrade pip
RUN apt-get update \
 && apt-get install -y \
  gcc libssl-dev postgresql-client python3 python3-pip python3-setuptools openssh-client \
 && apt-get -y clean && rm -rf /var/lib/apt/lists/* \
 && pip3 install --upgrade pip

# create dirs and add the app
RUN mkdir -p /var/spool/vespene /etc/vespene/settings.d/ /var/log/vespene/
COPY . /opt/vespene/
RUN mv /opt/vespene/docker/worker/run.sh / && chmod +x /run.sh

RUN python3 -m pip install -r /opt/vespene/requirements.txt --trusted-host pypi.org --trusted-host files.pypi.org --trusted-host files.pythonhosted.org

# set up
WORKDIR /opt/vespene

# Use the same DB as for the server
ENV DB_SERVER="db"
ENV DB_USER="vespene"
ENV DB_NAME="vespene"
ENV DB_PASSWORD="vespene!"

ENV BUILDROOT="/tmp/vespene"

ENTRYPOINT ["/run.sh"]
CMD ["general"]