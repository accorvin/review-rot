FROM centos:8
MAINTAINER Pavlina Bortlova <pbortlov@redhat.com>

LABEL description="Review-rot - gather information about opened merge or pull requests"
LABEL summary="review-rot git gitlab github pagure gerrit"
LABEL vendor="PnT DevOps Automation - Red Hat, Inc."

USER root

RUN yum install -y epel-release && yum update -y && \
    yum install -y git gcc python3-devel \
    python3-setuptools python3-pip && \
    yum clean all

# copy workdir for installation of review-rot
WORKDIR /reviewrot
ADD . /reviewrot

# install review-rot
RUN pip3 install --upgrade pip setuptools && python3 setup.py install

# create direcory for the run of review-rot,
# set privileges and env variable
RUN mkdir -p /.cache/Python-Eggs && chmod g+rw /.cache/Python-Eggs
ENV PYTHON_EGG_CACHE=/.cache/Python-Eggs
ENTRYPOINT date \
           && review-rot -c /secret/configuration.yaml -f json --debug --reverse > /opt/data/data-pending.json \
           && mv /opt/data/data-pending.json /opt/data/data.json;
