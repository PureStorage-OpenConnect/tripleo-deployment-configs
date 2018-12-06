FROM registry.access.redhat.com/rhosp13/openstack-cinder-volume
MAINTAINER Pure Storage, Inc.
LABEL name="rhosp13/openstack-cinder-volume-pure" vendor="Pure Storage" version="1.0" release="1" description="Red Hat OpenStack Platform 13.0 cinder-volume Pure Storage FlashArray"
USER root
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.n
oarch.rpm
RUN yum install python-pip -y
RUN /usr/bin/pip install purestorage
# switch the container back to the default user
USER root
