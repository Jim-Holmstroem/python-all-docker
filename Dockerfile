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
    fontconfig \
    htop \
    llvm-dev \
    llvm-3.5 \
    llvm-3.5-dev \
    libavcodec-dev \
    libavformat-dev \
    libatlas-base-dev \
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
    libncurses5 \
    libncurses5-dev \
    libpng-dev \
    libpq-dev \
    libssl-dev \
    libswscale-dev \
    libtbb-dev \
    libtiff-dev \
    libxml2 \
    libxml2-dev \
    libxslt1.1 \
    libxslt1-dev \
    libyaml-dev \
    libzmq3 \
    libzmq3-dev \
    ntp \
    pkg-config \
    python \
    python-dev \
    python-pip \
    ranger \
    swig \
    zlib1g \
    zlib1g-dev

RUN pip install --upgrade pip

ENV LLVM_CONFIG /usr/bin/llvm-config-3.5

COPY aip.py /usr/local/bin/aip
RUN chmod +x /usr/local/bin/aip
COPY requirements.txt /etc/requirements.txt

RUN pip install $(cat /etc/requirements.txt | grep "cython==") && \
    pip install $(cat /etc/requirements.txt | grep "numpy==") && \
    pip install $(cat /etc/requirements.txt | grep "scipy==") && \
    pip install $(cat /etc/requirements.txt | grep "pandas==")

ADD https://github.com/matplotlib/basemap/archive/v1.0.7rel.zip /tmp/basemap-1.0.7
RUN cd /tmp/basemape-1.0.7 && python setup.py install && cd -

ADD https://github.com/Blosc/bcolz/archive/v0.8.1.zip /tmp/colz-0.8.1
RUN cd /tmp/colz-0.8.1 && python setup.py install && cd -

RUN aip install --requirement /etc/requirements.txt
