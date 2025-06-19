FROM registry.redhat.io/rhosp-rhel9/openstack-manila-share:17.1.5
MAINTAINER Pure Storage, Inc.
LABEL name="rhosp18/openstack-manila-shr-pure" vendor="Pure Storage" version="1.0" release="17" summary="Red Hat OpenStack Platform 17.1 manila-shr Pure Storage FlashBlade" description="Manila plugin for Pure Storage FlashBlade"
USER root
RUN dnf install -y http://rpmfind.net/linux/epel/9/Everything/x86_64/Packages/p/python3-certifi-2023.05.07-4.el9.noarch.rpm
RUN dnf install -y https://github.com/PureStorage-OpenConnect/tripleo-deployment-configs/raw/master/manila/RHOSP17.1/python3-purity_fb-1.12.3-1.el9.noarch.rpm
RUN yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --allowerasing
# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)
COPY licenses /licenses
# switch the container back to the default user
USER manila
