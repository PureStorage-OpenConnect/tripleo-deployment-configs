Introduction
============

This document covers the configuration process required to enable a
single Pure Storage array to be used as an iSCSI or Fibre Channel 
Cinder Block Storage backend in Red Hat OpenStack distributions.

The following items are assumed by this document:

-  Ensure your Red Hat OpenStack Platform Overcloud has been correctly
   deployed through the Director, with a correctly functioning Block
   Storage service.

-  Your Pure Storage Array should be available in the cloud management
   network or routed to the cloud management network with the Pure
   Storage iSCSI ports correctly configured, if using this protocol.

-  The Pure Storage management IP (and iSCSI port IPs if applicable) must have
   connectivity from the controller and compute nodes.

-  You have obtained a privileged API token from the Pure Storage
   FlashArray that will be used by OpenStack Block Storage service.

When RHEL OpenSstack Platform is deployed through the Director, all
major Overcloud settings must be defined and orchestrated through the
Director as well. This will ensure that the settings persist through any
Overcloud updates.

This document will not discuss the different deployment configurations
possible with the backend. To learn more about these see the OpenStack
Best Practises documents provided by Pure Storage.

At present, the Director only has the integrated components to deploy a
single instance of a Pure Storage backend. Therefore this document only
describes the deployment of a single backend.

Configure Pure Storage as a Cinder backend
==========================================

RHEL OpenStack Platform includes all the drivers and puppet manifests
required for the Pure Storage FlashArray, however, there are a number of
environment files required to be added to your Undercloud for full
integration of the FlashArray into your Overcloud.

The YAML environment files required can be found on the Pure Storage OpenConnect
GitHub repository
https://github.com/PureStorage-OpenConnect/tripleo-deployment-configs.
Select the correct sub-directory for the deployment version you are using.

RHOSP8 and 9
============

Obtain the YAML files from this repository and copy into the following
locations in your Undercloud:

``pure-controller-temp.yaml``, ``pure-temp.yaml`` and ``cinder-pure-config.yaml`` into ``~stack/templates/``

``cinder-pure.yaml`` into ``/usr/share/openstack-tripleo-heat-templates/puppet/extraconfig/pre_deploy/controller/``

RHOSP13 and 14
==============

Copy the YAML files from this subdirectory into the following
locations in your Undercloud:

``pure-temp.yaml`` and ``cinder-pure-config.yaml`` into ``~stack/templates/``

Use the ``Dockerfile`` to create a Pure Storage specific Cinder Volume
container::

  $ docker build . -t "openstack-cinder-volume-pure:latest"

This newly created image can then be pushed to a registry that has been configured
as the sources of images to be used by the RHOSP deployment.

Red Hat Certified versions of these containers can also be used. These can be found
in the Red Hat Container Catalog. See https://catalog.redhat.com/software/containers/search?q=pure&p=1

Edit the overcloud container images environment file (usually
``overcloud_images.yaml``, created when using the
``openstack overcloud container image prepare`` command) and change the
appropriate parameter to use the custom container image.

RHOSP15
=======

Copy the YAML files from this subdirectory into the following
locations in your Undercloud:

``pure-temp.yaml`` and ``cinder-pure-config.yaml`` into ``~stack/templates/``

Use the ``Dockerfile`` to create a Pure Storage specific Cinder Volume
container::

  $ docker build . -t "openstack-cinder-volume-pure:latest"

This newly created image can then be pushed to a registry that has been configured
as the sources of images to be used by the RHOSP deployment.

Red Hat Certified versions of these containers can also be used. These can be found
in the Red Hat Container Catalog. See https://catalog.redhat.com/software/containers/search?q=pure&p=1

Edit the overcloud container images environment file (usually
``overcloud_images.yaml``, created when using the
``openstack overcloud container image prepare`` command) and change the
appropriate parameter to use the custom container image.

RHOSP16 (RHEL8)
===============

Copy the YAML files from this subdirectory into the following
locations in your Undercloud:

``pure-temp.yaml`` and ``cinder-pure-config.yaml`` into ``~stack/templates/``

Use the ``Dockerfile`` to create a Pure Storage specific Cinder Volume
container::

  $ sudo buildah bud . -t "openstack-cinder-volume-pure:latest"

This newly created image can then be pushed to a local registry that has been configured
as the sources of images to be used by the RHOSP deployment::

  $ sudo openstack tripleo container image push --local <registry:port>/<directory>/openstack-cinder-volume-pure:latest

Red Hat Certified versions of these containers can also be used. These can be found
in the Red Hat Container Catalog. See https://catalog.redhat.com/software/containers/search?q=pure&p=1

Edit the overcloud container images environment file (usually
``overcloud_images.yaml``, created when using the
``openstack overcloud container image prepare`` command) and change the
appropriate parameter to use the custom container image.

All versions - Configure the Environment File
=============================================

Edit ``~/templates/cinder-pure-config.yaml`` and populate it with your specific
FlashArray data.

In the ``parameter_defaults`` section of this file add the management
virtual IP address of your FlashArray into the ``CinderPureSanIp`` parameter
and the API Token you had from your FlashArray into the
``CinderPureAPIToken`` parameter.

Optionally, you can configure your FlashArray to use the iSCSI CHAP
security protocol by changing the default parameter setting of false to
be true in the parameter ``CinderPureUseChap``.

Multiple Backends
#################

If you wish to create multiple Pure backends then use ``CinderPureMultiConfig``
when modifying the ``~/templates/cinder-pure-config.yaml`` as follows:::

   parameter_defaults:
     CinderPureBackendName:
       - tripleo_pure_1
       - tripleo_pure_2
     CinderPureStorageProtocol: 'iSCSI' # Default value for all Pure backends
     CinderPureUseChap: false # Default value for the Pure backends
     CinderPureMultiConfig:
       tripleo_pure_1:
         CinderPureSanIp: '10.0.0.1'
         CinderPureAPIToken: 'secret'
       tripleo_pure_2:
         CinderPureSanIp: '10.0.0.2'
         CinderPureAPIToken: 'anothersecret'
         CinderPureUseChap: true # Specific value for this backend


Requirements
============

To deploy the Pure Storage FlashArray Cinder driver you must meet the following
requirements:

- Pure Storage FlashArrays deployed and ready to be used as Cinderbackends
- RHOSP Director user credentials to deploy the Overcloud
- RHOSP Overcloud Controller nodes where the Cinder services will be installed  

Deploying the Configured Backend
================================

To deploy the single backend configured above, first, log in as the
stack user to the Undercloud. Then deploy the backend (defined in the
edited ``~/templates/cinder-pure-config.yaml``) by running the
``openstack overcloud deploy`` with the required switches for your
deployment version together with an additonal templates file defined
by ``–e ~/templates/cinder-pure-config.yaml``::

  $ openstack overcloud deploy --templates -e ~/templates/cinder-pure-config.yaml

If you passed any extra environment files when you created the Overcloud
you must pass them again here using the ``–e`` option to avoid making
undesired changes to the Overcloud.

Test the Configured Backend
===========================

After deploying the backend, test whether you can successfully create
volumes on it. Doing so will require loading the necessary environment
variables first. These variables are defined in ``/home/stack/overcloudrc``
by default.

To load these variables, run the following command as the stack user::

  $ source /home/stack/overcloudrc

You should now be logged into the Controller node. From there you can
create a *volume type*, which can be used to specify the back end you
want to use (in this case the newly-defined backend). This is required
in an OpenStack deployment where you have other backends enabled.

To create a volume type named pure, run::

  $ cinder type-create pure

Next, map this volume type to the backend defined above and given the
backend name ``tripleo_pure`` (as defined in through the
**CinderPureBackendName** parameter) by running::

  $ cinder type-key pure set volume_backend_name=tripleo_pure

You should now be able to create a 2GB volume on your newly defined
backend by invoking its volume type. To do this run::

  $ cinder create --volume-type pure 2
