FROM ubuntu:14.04

USER root

RUN ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime

RUN apt-get update && apt-get install --assume-yes \
    build-essential \
    cmake \
    cython \
    gcc \
    git \
    gfortran \
    htop \
    llvm-dev \
    llvm-3.5 \
    llvm-3.5-dev \
    libavcodec-dev \
    libavformat-dev \
    libblas-dev \
    libcurl4-openssl-dev \
    libdc1394-22-dev \
    libedit2 \
    libedit-dev \
    libev4 \
    libev-dev \
    libffi6 \
    libffi-dev \
    libfreetype6 \
    libfreetype6-dev \
    libgtk2.0-dev \
    libhdf5-7 \
    libhdf5-dev \
    libjpeg-dev \
    libjasper-dev \
    liblapack-dev \
    libnetcdf-dev \
    libnetcdfc7 \
    libnetcdfc++4 \
    libpng-dev \
    libpq-dev \
    libswscale-dev \
    libtbb-dev \
    libtiff-dev \
    libxml2 \
    libxml2-dev \
    libxslt1.1 \
    libxslt1-dev \
    ntp \
    pkg-config \
    python \
    python-dev \
    python-pip \
    ranger \
    zlib1g \
    zlib1g-dev

ENV LLVM_CONFIG /usr/bin/llvm-config-3.5

COPY aip.py /usr/local/bin/aip
RUN chmod +x /usr/local/bin/aip
COPY requirements.txt /etc/requirements.txt

RUN aip install --requirement /etc/requirements.txt
