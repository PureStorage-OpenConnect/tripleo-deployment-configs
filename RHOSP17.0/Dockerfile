FROM registry.redhat.io/rhosp-rhel9/openstack-cinder-volume:17.0
MAINTAINER Pure Storage, Inc.
LABEL name="rhosp17/openstack-cinder-volume-pure" vendor="Pure Storage" version="1.0" release="17" summary="Red Hat OpenStack Platform 17.0 cinder-volume Pure Storage FlashArray" description="Cinder plugin for Pure Storage FlashArray"
USER root
RUN yum install -y https://github.com/PureStorage-OpenConnect/tripleo-deployment-configs/raw/master/RHOSP17.0/python3-purestorage-1.19.0-1.el9.noarch.rpm
RUN yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical
# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)
COPY licenses /licenses
# switch the container back to the default user
USER cinder
