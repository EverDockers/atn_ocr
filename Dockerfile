FROM ubuntu:16.04
MAINTAINER Baker Wang <baikangwang@hotmail.com>

#usage: docker run -it -v projects:/projects -p 6006:6006 baikangwang/tensorflow_cpu:tfonly

#
# Set the locale
#
# https://stackoverflow.com/questions/28405902/how-to-set-the-locale-inside-a-docker-container
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install -y locales && \
    #
    # Cleanup
    #
    apt clean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*

RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8  
ENV LANGUAGE en_US:en  
ENV LC_ALL en_US.UTF-8

#
# initial
#
RUN apt update && \
    apt install -y --no-install-recommends apt-utils \
    # Developer Essentials
    git curl vim unzip wget \
    #
    #
    #
    # Build tools
    build-essential cmake \
    # OpenBLAS
    libopenblas-dev \
    # Pillow and it's dependencies
    libjpeg-dev zlib1g-dev && \
    #
    # Cleanup
    #
    apt clean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*
#
# Python 3.5
#
RUN apt update && \
    apt install -y --no-install-recommends python3.5 python3.5-dev python3-pip && \
    pip3 install --no-cache-dir --upgrade pip setuptools && \
    echo "alias python='python3'" >> /root/.bash_aliases && \
    echo "alias pip='pip3'" >> /root/.bash_aliases && \
    #
    # Cleanup
    #
    apt clean && \
    apt autoremove && \
    rm -rf /var/lib/apt/lists/*
#
# common libs
#
RUN pip3 --no-cache-dir --upgrade install Pillow \
    # Common libraries
    numpy scipy sklearn scikit-image pandas matplotlib \
    #
    # Prerequsites
    # Tensorflow 1.2.1 - CPU
    #
    tensorflow==1.2.1 \
    # tqdm
    tqdm && \
    # Distance
    wget http://www.cs.cmu.edu/~yuntiand/Distance-0.1.3.tar.gz && \
    tar zxf Distance-0.1.3.tar.gz && \
    cd distance && python3 setup.py install && \
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