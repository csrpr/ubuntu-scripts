

CALIXTO_IMAGE_PATH_COMMON = '${DEPOLY_DIR}/home/calixto-systems/rpr/yocto/calixto-yocto-wordir-ti/calixto-images/${MACHINE}'
CALIXTO_IMAGE_PATH_SDCARD = '${DEPOLY_DIR}/home/calixto-systems/rpr/yocto/calixto-yocto-wordir-ti/calixto-images/${MACHINE}/sdcard'


create_calixto_versa_image () {

mkdir -p ${CALIXTO_IMAGE_PATH_COMMON}
rm -rf ${CALIXTO_IMAGE_PATH_COMMON}/*

mkdir -p ${CALIXTO_IMAGE_PATH_SDCARD}
rm -rf ${CALIXTO_IMAGE_PATH_SDCARD}/*

cp -v ${DEPLOY_DIR_IMAGE}/zImage ${CALIXTO_IMAGE_PATH_SDCARD}
cp -v ${DEPLOY_DIR_IMAGE}/am335x-calixto-nxt.dtb ${CALIXTO_IMAGE_PATH_SDCARD}
cp -v ${DEPLOY_DIR_IMAGE}/u-boot.img ${CALIXTO_IMAGE_PATH_SDCARD}
cp -v ${DEPLOY_DIR_IMAGE}/MLO ${CALIXTO_IMAGE_PATH_SDCARD}
cp -v ${DEPLOY_DIR_IMAGE}/MLO.byteswap ${CALIXTO_IMAGE_PATH_SDCARD}

cp -v ${DEPLOY_DIR_IMAGE}/${IMAGE_ROOTFS} ${CALIXTO_IMAGE_PATH_SDCARD}
cp -v ${DEPLOY_DIR_IMAGE}/${IMAGE_ROOTFS} ${CALIXTO_IMAGE_PATH_SDCARD}/rootfs.tar

}
