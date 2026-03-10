FROM registry.redhat.io/rhoso/openstack-manila-share-rhel9:18.0.16

ARG min_pureclient_version=1.12.3

LABEL maintainer="Everpure" \
      description="OpenStack manila-share Everpure" \
      summary="OpenStack manila-share Everpure" \
      name="manila-share-pure:osp18" \
      vendor="Everpure" \
      min_pureclient="${pureclient_version}"

# Switch to root to install software depedencies
USER root
RUN dnf install -y python3-pip
RUN python3 -m pip install certifi purity_fb
#RUN dnf install -y https://github.com/PureStorage-OpenConnect/tripleo-deployment-configs/raw/master/manila/RHOSP17.1/python3-purity_fb-1.12.3-1.el9.noarch.rpm --nobest
RUN dnf clean all
# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)
RUN mkdir /licenses
COPY licenses /licenses
# Switch to cinder user
USER manila
