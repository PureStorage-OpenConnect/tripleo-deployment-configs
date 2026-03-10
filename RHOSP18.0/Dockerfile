FROM registry.redhat.io/rhoso/openstack-cinder-volume-rhel9:18.0.17

ARG min_pureclient_version=1.19.0

LABEL maintainer="Everpure" \
      description="OpenStack cinder-volume Everpure" \
      summary="OpenStack cinder-volume Everpure" \
      name="cinder-volume-pure:osp18" \
      vendor="Everpure" \
      maintainer="simon@purestorage.com" \
      min_pureclient="${pureclient_version}"

# Switch to root to install software depedencies
USER root
RUN dnf clean all && dnf install -y libstoragemgmt-udev
RUN dnf install -y https://github.com/PureStorage-OpenConnect/tripleo-deployment-configs/raw/master/RHOSP17.1/python3-purestorage-1.19.0-1.el9.noarch.rpm
# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)
RUN mkdir /licenses
COPY licenses /licenses
# Switch to cinder user
USER cinder
