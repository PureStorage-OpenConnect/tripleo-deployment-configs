FROM registry.redhat.io/rhosp-rhel8/openstack-cinder-volume:16.2.7
MAINTAINER Pure Storage, Inc.
LABEL name="rhosp16/openstack-cinder-volume-pure" vendor="Pure Storage" version="1.0" release="16" summary="Red Hat OpenStack Platform 16.2 cinder-volume Pure Storage FlashArray" description="Cinder plugin for Pure Storage FlashArray"
USER root
RUN yum install -y libstoragemgmt-udev
RUN yum install -y https://github.com/PureStorage-OpenConnect/tripleo-deployment-configs/raw/master/RHOSP16.2/python3-purestorage-1.18.1-1.el8.noarch.rpm
# RUN yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --nobest
RUN mpathconf --enable
# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)
COPY licenses /licenses
# switch the container back to the default user
USER cinder
