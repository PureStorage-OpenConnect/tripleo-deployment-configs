FROM registry.redhat.io/rhosp-rhel8/openstack-manila-shr:17.0
MAINTAINER Pure Storage, Inc.
LABEL name="rhosp17/openstack-manila-shr-pure" vendor="Pure Storage" version="1.0" release="18" summary="Red Hat OpenStack Platform 18.0 manila-shr Pure Storage FlashBlade" description="Manila plugin for Pure Storage FlashBlade"
USER root
RUN yum install -y https://github.com/PureStorage-OpenConnect/tripleo-deployment-configs/raw/master/RHOSP18.0-manila/python3-purity_fb-12.2-1.el8.noarch.rpm
RUN yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical
RUN mpathconf --enable
# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)
COPY licenses /licenses
# switch the container back to the default user
USER manila
