FROM registry.redhat.io/rhosp-dev-preview/openstack-cinder-volume-rhel9:18.0

ARG min_pureclient_version=1.17.0

LABEL maintainer="Pure Storage" \
      description="OpenStack cinder-volume Pure Storage" \
      summary="OpenStack cinder-volume Pure Storage" \
      name="cinder-volume-pure:osp18" \
      vendor="Pure Storage" \
      min_pureclient="${pureclient_version}"

# Switch to root to install software depedencies
USER root
RUN yum install -y libstoragemgmt-udev
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && \
    python3 get-pip.py && \
    pip3 install "purestorage>=${min_pureclient_version}" && \
    rm -f get-pip.py
RUN yum -y update-minimal --security --sec-severity=Important --sec-severity=Critical --nobest
# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)
COPY licenses /licenses
# Switch to cinder user
USER cinder
