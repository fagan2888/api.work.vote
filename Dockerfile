FROM python:3.5.6

RUN apt-get update -y && \
    apt-get install --auto-remove -y \
      libmemcached-dev \
      libsqlite3-mod-spatialite \
      zlib1g-dev \
      mdbtools \
      vim \
      binutils \
      libproj-dev \
      gdal-bin \
      postgis \
      curl \
      locales \
      apt-transport-https && \
    rm -rf /var/lib/apt/lists/*

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && /usr/sbin/locale-gen

ENV HOME=/home/fec
WORKDIR $HOME

RUN pip install rasterio
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

COPY ./ $HOME/api/
WORKDIR $HOME/api/

CMD gunicorn config.wsgi:application --log-file -
