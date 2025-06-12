#!/bin/bash -x
#

usage()
{
	echo "Usage: $0 -v <RHOSP version> -t <tag value>"
	exit
}

if [ $# -eq 0 ]; then
	usage
	exit 1
fi

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
	usage
	exit 1
fi

while getopts ":v:ti:" OPTION
do
	case "$OPTION" in
		v)
			VERSION=${OPTARG}
			;;
		t)
			TAG=${OPTARG}
			;;
		*)
			usage
			;;
	esac
done

if [ -z ${VERSION} ]; then
	echo "-v option required"
	exit 1
fi
TAG="18.0.8"
if [ -z ${TAG} ]; then
	MAJOR=(${VERSION//./ })
	case "$MAJOR" in
		16)
			TAG=$(podman search --list-tags registry.redhat.io/rhosp-rhel8/openstack-cinder-volume | grep ${VERSION} | grep -v source | sort -k2 |  awk '{ print $2 }' | tail -1)
			;;
		17)
			TAG=$(podman search --list-tags registry.redhat.io/rhosp-rhel9/openstack-cinder-volume | grep ${VERSION} | grep -v source | sort -k2 |  awk '{ print $2 }' | tail -1)
			;;
		18)
			TAG=$(podman search --list-tags registry.redhat.io/registry.redhat.io/rhoso/openstack-cinder-volume-rhel9 | grep ${VERSION} | grep -v source | sort -k2 |  awk '{ print $2 }' | tail -1)
			;;
	esac
	echo "
	*********************
	Using latest tag: ${TAG}
	*********************
	"
fi
case "$VERSION" in
	16.1)
		CERT_ID="5f75e819f520cf14a1995457"

		podman login -u redhat-isv-containers+5f75e819f520cf14a1995457-robot -p 482XI6L5XUAX3WC0KS31D36LGXSQITWK2DTYCQFYM56XKY9VKGEWYQ97Y18U2FEP quay.io --authfile ./rhauth.json
		;;
	16.2)
		CERT_ID="606e0c1f6b0681eb0f1fd1d0"
		podman login -u redhat-isv-containers+606e0c1f6b0681eb0f1fd1d0-robot -p E4BIA6QG63EAZOBMUBJFR82RYLUN24NCVD6IC2YGOO5264NAQYVW6F6L6NIAU1B4 quay.io --authfile ./rhauth.json
		;;
	17.0)
		CERT_ID="636972fbba9db20e765d0085"
		podman login -u redhat-isv-containers+636972fbba9db20e765d0085-robot -p 0ILZF3WSI2Z44H4N6VW5CD2PF841B8M7YK91TVWLASMUOTK7GARH39V6OI5QGJJO quay.io --authfile ./rhauth.json
		;;
	17.1)
		CERT_ID="648b3fa6c0db34d8a0ca31c9"
		podman login -u redhat-isv-containers+648b3fa6c0db34d8a0ca31c9-robot -p 6QJBK2BBPZ4JW282MLSN503OY7C2D2I0A6VY2UUGM6J3PS6FY6Q0RY1R4HJK5RXG quay.io --authfile ./rhauth.json
		;;
	18.0)
		CERT_ID="6668bfeaed14eee6fc4b19b0"
		podman login -u purestorage+rhoso_robot -p EILTIW2Y5TSL111A0ZFU77GIKMX6GACN9R4KZXC6VXEH48WRK77QRNIZ3CKVG04B quay.io --authfile ./rhauth.json
		;;
	*)
		echo "Unsupported version"
		exit 1
esac

#PFLT_PYXIS_HOST=catalog.uat.redhat.com/api/containers

cd RHOSP${VERSION}
#sed -i '0,/${VERSION}/s//${TAG}/' Dockerfile
buildah build .
#sed -i '0,/${TAG}/s//${VERSION}/' Dockerfile

TAGVERSION=${VERSION/./-}
IMAGE=$(podman images | head -2 - | tail -1 - | awk '{ print $3 }')

echo "Tagging and uploading new image..."
case "$VERSION" in
	18.0)
		podman tag $IMAGE quay.io/purestorage/rhoso-cinder:$TAG
		podman push quay.io/purestorage/rhoso-cinder:$TAG --authfile=../rhauth.json
		podman tag $IMAGE quay.io/purestorage/rhoso-cinder:$VERSION
		podman push quay.io/purestorage/rhoso-cinder:$VERSION --authfile=../rhauth.json
		podman tag $IMAGE quay.io/purestorage/rhoso-cinder:latest
		podman push quay.io/purestorage/rhoso-cinder:latest --authfile=../rhauth.json
		sleep 5
		echo "Running certification preflight..."
		preflight check container quay.io/purestorage/rhoso-cinder:$TAG --docker-config=../rhauth.json

		echo "Submitting certified image..."
		preflight check container quay.io/purestorage/rhoso-cinder:$TAG --submit --pyxis-api-token=giq1q8l2jf456t53fhkliiu11cc23mbz --certification-component-id=$CERT_ID --docker-config=../rhauth.json

		;;
	*)
		podman tag $IMAGE quay.io/redhat-isv-containers/$CERT_ID:$TAG
		podman push quay.io/redhat-isv-containers/$CERT_ID:$TAG --authfile=../rhauth.json
		podman tag $IMAGE quay.io/redhat-isv-containers/$CERT_ID:latest
		podman push quay.io/redhat-isv-containers/$CERT_ID:latest --authfile=../rhauth.json
		podman tag $IMAGE quay.io/redhat-isv-containers/$CERT_ID:$VERSION
		podman push quay.io/redhat-isv-containers/$CERT_ID:$VERSION --authfile=../rhauth.json
		sleep 5

		echo "Running certification preflight..."
		preflight check container quay.io/redhat-isv-containers/$CERT_ID:$TAG --docker-config=../rhauth.json

		echo "Submitting certified image..."
		preflight check container quay.io/redhat-isv-containers/$CERT_ID:$TAG --submit --pyxis-api-token=cogrgu8jxhr65w97rkct2rg9ozlwetz2 --certification-component-id=$CERT_ID --docker-config=../rhauth.json
		;;
esac
#podman rmi $IMAGE
#rm ../rhauth.json
echo ""
echo "Go to Red Hat Portal and publish this image - adding latest tag at the same time"
exit 0
