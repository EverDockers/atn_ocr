FROM ubuntu:16.04
MAINTAINER Baker Wang <baikangwang@hotmail.com>

#usage: docker run -it -v projects:/projects -p 6006:6006 baikangwang/tensorflow_cpu:tfonly2

RUN apt update && \
    apt install -y --no-install-recommends apt-utils \
    # Developer Essentials
    git curl vim unzip wget && \
    #
    # Cleanup
    #
    apt clean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*
#
# Python 2.7
#
RUN apt update && \
    apt install -y --no-install-recommends python2.7 python-dev python-pip && \
    pip install --no-cache-dir --upgrade pip setuptools && \
    #
    # Cleanup
    #
    apt clean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

#
# Prerequsites
# Tensorflow 1.2.1 - CPU
# tqdm
# Distance
#
RUN pip install --no-cache-dir --upgrade tensorflow==1.2.1 tqdm && \
    wget http://www.cs.cmu.edu/~yuntiand/Distance-0.1.3.tar.gz && \
    tar zxf Distance-0.1.3.tar.gz && \
    cd distance && \ python setup.py install && \
    cd / && rm Distance-0.1.3.tar.gz && rm -rf distance

#
# Specify working folder
#
RUN mkdir /projects
WORKDIR "/projects"

#
# Tensorboard : 6006
#
EXPOSE 6006

CMD ["/bin/bash"]