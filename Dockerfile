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
    libiodbc2-dev \
    libjpeg-dev \
    libjasper-dev \
    liblapack-dev \
    libnetcdf-dev \
    libnetcdfc7 \
    libnetcdfc++4 \
    libncurses5 \
    libncurses5-dev \
    libopenmpi-dev \
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
    mesa-common-dev \
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

COPY requirements.txt /etc/requirements.txt

RUN pip install $(cat /etc/requirements.txt | grep "cython==") && \
    pip install $(cat /etc/requirements.txt | grep "numpy==") && \
    pip install $(cat /etc/requirements.txt | grep "scipy==") && \
    pip install $(cat /etc/requirements.txt | grep "pandas==")

ADD http://download.osgeo.org/geos/geos-3.3.9.tar.bz2 /tmp/geos-3.3.9.tar.gz
RUN cd /tmp && tar -xvf geos-3.3.9.tar.gz && cd geos-3.3.9 && mkdir build && cd build && cmake .. && make && make install

ADD https://github.com/Blosc/bcolz/archive/v0.8.1.tar.gz /tmp/bcolz-0.8.1.tar.gz
RUN cd /tmp && tar -xvf bcolz-0.8.1.tar.gz && cd bcolz-0.8.1 && python setup.py install

ADD http://download.osgeo.org/gdal/1.11.2/gdal-1.11.2.tar.gz /tmp/gdal-1.11.2.tar.gz
RUN cd /tmp && tar -xvf gdal-1.11.2.tar.gz && cd gdal-1.11.2 && \
    ./configure --with-python && \
    make && \
    cd swig/python && \
    make veryclean && make generate && \
    cd - \
    make install && \
    ldconfig

COPY aip.py /usr/local/bin/aip
RUN chmod +x /usr/local/bin/aip
RUN aip install --requirement /etc/requirements.txt
