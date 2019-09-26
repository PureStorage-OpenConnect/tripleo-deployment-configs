FROM registry.redhat.io/rhosp15-rhel8/openstack-cinder-base
MAINTAINER Pure Storage, Inc.
LABEL name="rhosp15/openstack-cinder-volume-pure" vendor="Pure Storage" version="1.0" release="15" summary="Red Hat OpenStack Platform 15.0 cinder-volume Pure Storage FlashArray" description="Cinder plugin for Pure Storage FlashArray"
USER root
RUN yum install -y python2-requests
RUN yum install -y https://github.com/PureStorage-OpenConnect/tripleo-deployment-configs/raw/master/RHOSP15/python2-purestorage-1.16.0-1.el7.noarch.rpm
RUN mpathconf --enable
# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)
COPY licenses /licenses
# switch the container back to the default user
USER cinder
