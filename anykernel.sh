# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=LineageKSU by skye-tachyon @ xda-developers
do.devicecheck=1
do.modules=0
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=r8q
device.name2=r8qxx
device.name3=r8qxxx
supported.versions=14 - 17
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/platform/soc/1d84000.ufshc/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 0 755 644 $ramdisk/*;
set_perm_recursive 0 0 750 750 $ramdisk/init* $ramdisk/sbin;

## AnyKernel boot install

split_boot;

case "$ZIPFILE" in
   *-eff*)
    mv $home/kona-eff.dtb $home/dtb
    ;;
   *)
    mv $home/kona.dtb $home/dtb
    ;;
esac

dd if=$home/vbmeta.img of=/dev/block/platform/soc/1d84000.ufshc/by-name/vbmeta
dd if=$home/dtbo.img of=/dev/block/platform/soc/1d84000.ufshc/by-name/dtbo
flash_boot;
## end boot install
