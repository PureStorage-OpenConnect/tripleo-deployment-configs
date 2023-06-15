THIS DOCUMENT IS DRAFT UNTIL RHOSP18 IS RELEASED
================================================

Introduction
============

This document covers the configuration process required to enable a
single Pure Storage FlashBlade to be used as an NFS Manila Share 
backend in Red Hat OpenStack Platform distributions.

The following items are assumed by this document:

-  Ensure your Red Hat OpenStack Platform Overcloud has been correctly
   deployed through the Director, with a correctly functioning File
   Storage service.

-  Your Pure Storage FlashBlade should be available in the cloud management
   network or routed to the cloud management network with the Pure
   Storage FlashBlade management and data ports correctly configured.

-  The Pure Storage management IP must have connectivity from the Manila
   Share Service controller.

-  The Pure Storage data IP must have connectivity to all compute nodes.

-  You have obtained a privileged API token from the Pure Storage
   FlashBlade that will be used by OpenStack Manila Share service.

When RHEL OpenStack Platform is deployed through the Director, all
major Overcloud settings must be defined and orchestrated through the
Director as well. This will ensure that the settings persist through any
Overcloud updates.

This document will not discuss the different deployment configurations
possible with the backend. To learn more about these see the OpenStack
Best Practises documents provided by Pure Storage.

Configure Pure Storage as a Manila backend
==========================================

RHEL OpenStack Platform includes all the drivers and puppet manifests
required for the Pure Storage FlashBlade, however, there are a number of
environment files required to be added to your Undercloud for full
integration of the FlashBlade into your Overcloud.

The YAML environment files required can be found on the Pure Storage OpenConnect
GitHub repository
https://github.com/PureStorage-OpenConnect/tripleo-deployment-configs/manila.
Select the correct sub-directory for the deployment version you are using.

RHOSP 18 (RHEL9)
================

Copy the YAML file from this subdirectory into the following
locations in your Undercloud:

- ``manila-fb-config.yaml`` into ``~stack/templates/``

Use the ``Dockerfile`` to create a Pure Storage specific Manila Share
container::

  $ sudo buildah bud . -t "openstack-manila-share-flashblade:latest"

This newly created image can then be pushed to a local registry that has been configured
as the sources of images to be used by the RHOSP deployment::

  $ sudo openstack tripleo container image push --local <registry:port>/<directory>/openstack-manila-share-flashblade:latest

Red Hat Certified versions of these containers can also be used. These can be found
in the Red Hat Container Catalog. See https://catalog.redhat.com/software/containers/search?q=pure&p=1

Edit the overcloud container images environment file (usually
``overcloud_images.yaml``, created when using the
``openstack overcloud container image prepare`` command) and change the
appropriate parameter to use the custom container image.

All versions - Configure the Environment File
=============================================

Edit ``~/templates/manila-fb-config.yaml`` and populate it with your specific
FlashBlade data.

In the ``parameter_defaults`` section of this file add the management
virtual IP address and Data virtual IP of your FlashBlade into the ``ManilaFlashBladeMgmtIp``
and ``ManilaFlashBladeDataIp`` parameters respectively and the API Token
you had from your FlashBlade into the ``ManilaFlashBladeAPIToken`` parameter.

Requirements
============

To deploy the Pure Storage FlashBlade Manila driver you must meet the following
requirements:

- Pure Storage FlashBlade deployed and ready to be used as a Manila backend
- RHOSP Director user credentials to deploy the Overcloud
- RHOSP Overcloud Controller nodes where the Manila services will be installed  

Deploying the Configured Backend
================================

To deploy the single backend configured above, first, log in as the
stack user to the Undercloud. Then deploy the backend (defined in the
edited ``~/templates/manila-fb-config.yaml``) by running the
``openstack overcloud deploy`` with the required switches for your
deployment version ``–e ~/templates/manila-fb-config.yaml``::

  $ openstack overcloud deploy --templates -e ~/templates/manila-fb-config.yaml

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
create a *share type*, which can be used to specify the back end you
want to use (in this case the newly-defined backend). This is required
in an OpenStack deployment where you have other backends enabled.

To create a share type named flashblade, run::

  $ manila type-create flashblade

Next, map this share type to the backend defined above and given the
backend name ``tripleo_flashblade`` (as defined in through the
**ManilaFlashBladeBackendName** parameter) by running::

  $ manila type-key flashblade set share_backend_name=tripleo_flashblade

You should now be able to create a 1GB NFS share on your newly defined
backend by invoking its share type. To do this run::

  $ cmanila create --share-type flashblade NFS 1
