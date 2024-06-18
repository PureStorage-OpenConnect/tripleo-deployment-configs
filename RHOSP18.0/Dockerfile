FROM registry.redhat.io/rhoso-beta/openstack-cinder-volume-rhel9:18.0.0

ARG min_pureclient_version=1.19.0

LABEL maintainer="Pure Storage" \
      description="OpenStack cinder-volume Pure Storage" \
      summary="OpenStack cinder-volume Pure Storage" \
      name="cinder-volume-pure:osp18" \
      vendor="Pure Storage" \
      maintainer="simon@purestorage.com" \
      min_pureclient="${pureclient_version}"

# Switch to root to install software depedencies
USER root
RUN dnf clean all && dnf install -y libstoragemgmt-udev
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && \
    python3 get-pip.py && \
    pip3 install "purestorage>=${min_pureclient_version}" && \
    rm -f get-pip.py
# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)
RUN mkdir /licenses
COPY licenses /licenses
# Switch to cinder user
USER cinder
