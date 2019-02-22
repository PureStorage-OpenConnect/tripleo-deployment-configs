FROM registry.access.redhat.com/rhosp14/openstack-cinder-volume
MAINTAINER Pure Storage, Inc.
LABEL name="rhosp14/openstack-cinder-volume-pure" vendor="Pure Storage" version="1.0" release="14" description="Red Hat OpenStack Platform 14.0 cinder-volume Pure Storage FlashArray"
USER root
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install python-pip -y
RUN /usr/bin/pip install purestorage
# switch the container back to the default user
USER root
