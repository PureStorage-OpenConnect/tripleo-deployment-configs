FROM registry.redhat.io/rhosp-beta/openstack-manila-share:17.1

MAINTAINER Pure Storage, Inc.

LABEL name="rhosp17/openstack-manila-share-flashblade" \
      vendor="Pure Storage" \
      version="1.0" \
      release="17" \
      summary="Red Hat OpenStack Platform 17.1 manila-share Pure Storage FlashBlade" \
      description="Manila plugin for Pure Storage FlashBlade"

USER root

RUN yum install -y https://github.com/PureStorage-OpenConnect/tripleo-deployment-configs/raw/master/manila/RHOSP17.1/python3-purity_fb-1.12.3-1.el9.noarch.rpm

RUN yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical

# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)

COPY licenses /licenses

# switch the container back to the default user
USER manila
