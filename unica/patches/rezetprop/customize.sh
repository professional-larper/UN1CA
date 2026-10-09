BL_SPOOF="$(GET_PROP "ro.build.version.incremental")"
MODEL_SPOOF="$(GET_PROP "ro.product.system.model")"
SECURITY_PATCH="$(GET_PROP "ro.build.version.security_patch")"

echo "Rezetprop Setup"
echo "Spoofed BL: $BL_SPOOF"
echo "Spoofed Model: $MODEL_SPOOF"
echo "Security Patch: $SECURITY_PATCH"

if [[ -v SOURCE_PRODUCT_CODE ]]; then
    echo "Spoofed Product Code: $SOURCE_PRODUCT_CODE"
else
    echo "No referenced product code value was found in source"
fi

{
    echo "on property:service.bootanim.exit=1"
    echo "    exec u:r:init:s0 root root -- /system/bin/rezetprop -p -d persist.sys.pixelprops.games"
    echo "    exec u:r:init:s0 root root -- /system/bin/rezetprop -n ro.boot.flash.locked 1"
    echo "    exec u:r:init:s0 root root -- /system/bin/rezetprop -n ro.boot.vbmeta.device_state locked"
    echo "    exec u:r:init:s0 root root -- /system/bin/rezetprop -n ro.boot.verifiedbootstate green"
    echo "    exec u:r:init:s0 root root -- /system/bin/rezetprop -n ro.boot.veritymode enforcing"
    echo "    exec u:r:init:s0 root root -- /system/bin/rezetprop -n ro.boot.warranty_bit 0"
    printf '    exec u:r:init:s0 root root -- /system/bin/rezetprop -n ro.bootloader %s\n' "$BL_SPOOF"
    echo "    exec u:r:init:s0 root root -- /system/bin/rezetprop -n sys.oem_unlock_allowed 0"
    printf '    exec u:r:init:s0 root root -- /system/bin/rezetprop -n gsm.version.baseband %s,%s\n' "$BL_SPOOF" "$BL_SPOOF"
    printf '    exec u:r:init:s0 root root -- /system/bin/rezetprop -n ro.vendor.build.security_patch %s\n' "$SECURITY_PATCH"

    if [[ -v SOURCE_PRODUCT_CODE ]]; then
        printf '    exec u:r:init:s0 root root -- /system/bin/rezetprop -n ril.product_code %s\n' "$SOURCE_PRODUCT_CODE"
    fi

    printf '    exec u:r:init:s0 root root -- /system/bin/rezetprop -n ril.sw_ver %s\n' "$BL_SPOOF"
    printf '    exec u:r:init:s0 root root -- /system/bin/rezetprop -n ro.boot.em.model %s\n' "$MODEL_SPOOF"
    echo ""
} >> "$WORK_DIR/system/system/etc/init/hw/init.rc"

# shellcheck disable=SC2016
sed -i 's/${ro.boot.warranty_bit}/0/g' "$WORK_DIR/system/system/etc/init/init.rilcommon.rc"

echo "Setting up SEPolicy"

LINES="$(sed -n '/^(allow init init_exec\b/=' "$WORK_DIR/system/system/etc/selinux/plat_sepolicy.cil")"

for l in $LINES; do
    sed -i "${l} s/)))/ execute_no_trans)))/" "$WORK_DIR/system/system/etc/selinux/plat_sepolicy.cil"
done

echo "Patching complete!"
echo "Cleaning up..."

BL_SPOOF=
MODEL_SPOOF=
