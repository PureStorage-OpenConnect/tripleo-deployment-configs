FROM registry.redhat.io/rhoso-beta/openstack-manila-share-rhel9:18.0.0

ARG min_pureclient_version=1.12.3

LABEL maintainer="Pure Storage" \
      description="OpenStack manila-share Pure Storage" \
      summary="OpenStack manila-share Pure Storage" \
      name="manila-share-pure:osp18" \
      vendor="Pure Storage" \
      min_pureclient="${pureclient_version}"

# Switch to root to install software depedencies
USER root
RUN dnf clean all
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && \
    python3 get-pip.py && \
    pip3 install "purity_fb>=${min_pureclient_version}" && \
    rm -f get-pip.py
# Add required license as text file in Liceses directory (GPL, MIT, APACHE, Partner End User Agreement, etc)
RUN mkdir /licenses
COPY licenses /licenses
# Switch to cinder user
USER manila
