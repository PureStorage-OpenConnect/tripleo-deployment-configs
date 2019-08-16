FROM registry.redhat.io/rhosp-beta/openstack-cinder-volume
MAINTAINER Pure Storage, Inc.
LABEL name="rhosp15/openstack-cinder-volume-pure" vendor="Pure Storage" version="1.0" release="15" summary="Red Hat OpenStack Platform 15.0 cinder-volume Pure Storage FlashArray" description="Cinder plugin for Pure Storage FlashArray"
USER root
RUN subscription-manager register --org=6375131 --activationkey=OpenStack_DCI
RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install python-pip -y
RUN /usr/bin/pip install purestorage
RUN mpathconf --enable
# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)
COPY licenses /licenses
# switch the container back to the default user
USER cinder
