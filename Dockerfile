FROM ubuntu:18.04

# Install system packages
RUN apt-get update && apt-get install -y --no-install-recommends \
      bzip2 \
      g++ \
      git \
      graphviz \
      libgl1-mesa-glx \
      libhdf5-dev \
      openmpi-bin \
      wget

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

python3 -m pip install --upgrade pip

NB_USER=h3dema

RUN useradd -m -s /bin/bash -N $NB_USER && \
    mkdir -p /data && \
    chown $NB_USER /data

ADD ./requeriments.txt requeriments.txt
python3 -m pip install -r requeriments.txt

git clone git://github.com/lisa-lab/pylearn2.git
cd pylearn2
python setup.py develop


USER $NB_USER
WORKDIR /data

EXPOSE 8888
CMD jupyter notebook --port=8888 --ip=0.0.0.0
