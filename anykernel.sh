### AnyKernel3 Ramdisk Mod Script
## osm0sis @ xda-developers

### AnyKernel setup
# global properties
properties() { '
kernel.string=not_kernel by s-k-y.e @ xda-developers
do.devicecheck=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=r8q
device.name2=r8qxx
device.name3=r8qxxx
supported.versions=11 - 17
supported.patchlevels=
supported.vendorpatchlevels=
'; } # end properties


### AnyKernel install
## boot files attributes
boot_attributes() {
set_perm_recursive 0 0 755 644 $RAMDISK/*;
set_perm_recursive 0 0 750 750 $RAMDISK/init* $RAMDISK/sbin;
} # end attributes

# boot shell variables
BLOCK=/dev/block/platform/soc/1d84000.ufshc/by-name/boot;
IS_SLOT_DEVICE=0;
RAMDISK_COMPRESSION=auto;
PATCH_VBMETA_FLAG=auto;

# import functions/variables and setup patching - see for reference (DO NOT REMOVE)
. tools/ak3-core.sh;

# boot install
split_boot;

# begin cmdline changes
oneui=$(file_getprop /system/build.prop ro.build.version.oneui);
if [ -n "$oneui" ] && [ "$oneui" -ge 80000 ]; then
   patch_cmdline "android.is_aosp" "android.is_aosp=0";
   patch_cmdline "android.is_uos" "android.is_ous=1";
elif [ -n "$oneui" ]; then
   patch_cmdline "android.is_aosp" "android.is_aosp=0";
   patch_cmdline "android.is_uos" "android.is_ous=0";
else
   patch_cmdline "ro.boot.verifiedbootstate=orange" "ro.boot.verifiedbootstate=green";
   patch_cmdline "android.is_aosp" "android.is_aosp=1";
   patch_cmdline "android.is_uos" "android.is_ous=0";
fi

flash_generic vbmeta;
dd if=$home/vbmeta.img of=/dev/block/platform/soc/1d84000.ufshc/by-name/vbmeta
flash_generic dtbo;
dd if=$home/dtbo.img of=/dev/block/platform/soc/1d84000.ufshc/by-name/dtbo

flash_boot;
## end boot install
