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
		17)
			TAG=$(podman search --list-tags registry.redhat.io/rhosp-rhel9/openstack-manila-share | grep ${VERSION} | grep -v source | sort -k2 |  awk '{ print $2 }' | tail -1)
			;;
		18)
			TAG=$(podman search --list-tags registry.redhat.io/rhoso/openstack-manila-share-rhel9 | grep ${VERSION} | grep -v source | sort -k2 |  awk '{ print $2 }' | tail -1)
                        ;;
	esac
	echo "
	*********************
	Using latest tag: ${TAG}
	*********************
	"
fi
case "$VERSION" in
	17.1)
		CERT_ID="648b8b4da3ab224c155a06d9"
		podman login -u redhat-isv-containers+648b8b4da3ab224c155a06d9-robot -p MQOHIEH6XCT6P8UBFPAS73D4PHE68VHZ8GE0PVB6P95S64VSMOQ2CDRG9IAWAS1S quay.io --authfile ./rhauth.json
		;;
	18.0)
                CERT_ID="6668bfffdacea3a2334f06c9"
                podman login -u purestorage+rhoso_robot -p EILTIW2Y5TSL111A0ZFU77GIKMX6GACN9R4KZXC6VXEH48WRK77QRNIZ3CKVG04B quay.io --authfile ./rhauth.json
		;;
	*)
		echo "Unsupported version"
		exit 1
esac

#PFLT_PYXIS_HOST=catalog.uat.redhat.com/api/containers

cd manila/RHOSP${VERSION}
#sed -i '0,/${VERSION}/s//${TAG}/' Dockerfile
buildah build .
#sed -i '0,/${TAG}/s//${VERSION}/' Dockerfile

TAGVERSION=${VERSION/./-}
IMAGE=$(podman images | head -2 - | tail -1 - | awk '{ print $3 }')

case "$VERSION" in
        17.1)
		podman tag $IMAGE quay.io/redhat-isv-containers/$CERT_ID:$TAG
                podman push quay.io/redhat-isv-containers/$CERT_ID:$TAG --authfile=../../rhauth.json
                podman tag $IMAGE quay.io/redhat-isv-containers/$CERT_ID:latest
                podman push quay.io/redhat-isv-containers/$CERT_ID:latest --authfile=../../rhauth.json
                podman tag $IMAGE quay.io/redhat-isv-containers/$CERT_ID:$VERSION
                podman push quay.io/redhat-isv-containers/$CERT_ID:$VERSION --authfile=../../rhauth.json
                sleep 5
                echo "Running certification preflight..."
                preflight check container quay.io/redhat-isv-containers/$CERT_ID:$TAG --docker-config=../../rhauth.json
                echo "Submitting certified image..."
                preflight check container quay.io/redhat-isv-containers/$CERT_ID:$TAG --submit --pyxis-api-token=cogrgu8jxhr65w97rkct2rg9ozlwetz2 --certification-component-id=$CERT_ID --docker-config=../../rhauth.json
                ;;
        18.0)
                podman tag $IMAGE quay.io/purestorage/rhoso-manila:$TAG
                podman push quay.io/purestorage/rhoso-manila:$TAG --authfile=../../rhauth.json
                podman tag $IMAGE quay.io/purestorage/rhoso-manila:$VERSION
                podman push quay.io/purestorage/rhoso-manila:$VERSION --authfile=../../rhauth.json
                podman tag $IMAGE quay.io/purestorage/rhoso-manila:latest
                podman push quay.io/purestorage/rhoso-manila:latest --authfile=../../rhauth.json
                sleep 5
                echo "Running certification preflight..."
                preflight check container quay.io/purestorage/rhoso-manila:$TAG --docker-config=../../rhauth.json
                echo "Submitting certified image..."
                preflight check container quay.io/purestorage/rhoso-manila:$TAG --submit --pyxis-api-token=giq1q8l2jf456t53fhkliiu11cc23mbz --certification-component-id=$CERT_ID --docker-config=../../rhauth.json
                ;;
esac

#podman rmi $IMAGE
#rm ../rhauth.json
echo ""
echo "Go to Red Hat Portal and publish this image - adding latest tag at the same time"
exit 0
