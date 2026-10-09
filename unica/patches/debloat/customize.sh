# Dexpreopt
while IFS= read -r -d '' f; do
    DELETE_FROM_WORK_DIR "product" "${f#"$WORK_DIR/product/"}"
done < <(find "$WORK_DIR/product" -type d -name "oat" -print0)

while IFS= read -r -d '' f; do
    DELETE_FROM_WORK_DIR "system" "${f#"$WORK_DIR/system/"}"
done < <(find "$WORK_DIR/system" -type d -name "oat" -print0)

DELETE_FROM_WORK_DIR "system" "system/etc/boot-image.bprof"
DELETE_FROM_WORK_DIR "system" "system/etc/boot-image.prof"
DELETE_FROM_WORK_DIR "system" "system/framework/arm"
DELETE_FROM_WORK_DIR "system" "system/framework/arm64"

while IFS= read -r -d '' f; do
    DELETE_FROM_WORK_DIR "system" "${f#"$WORK_DIR/system/"}"
done < <(find "$WORK_DIR/system/system/framework" -type f -name "*.vdex" -print0)

while IFS= read -r -d '' f; do
    DELETE_FROM_WORK_DIR "system" "${f#"$WORK_DIR/system/"}"
done < <(find "$WORK_DIR/system/system/framework" -type f -name "*.fsv_meta" -print0)

if $TARGET_HAS_SYSTEM_EXT; then
    while IFS= read -r -d '' f; do
        DELETE_FROM_WORK_DIR "system_ext" "${f#"$WORK_DIR/system_ext/"}"
    done < <(find "$WORK_DIR/system_ext" -type d -name "oat" -print0)
fi

if $TARGET_HAS_PRODUCT; then
    while IFS= read -r -d '' f; do
        DELETE_FROM_WORK_DIR "product" "${f#"$WORK_DIR/product/"}"
    done < <(find "$WORK_DIR/product" -type d -name "oat" -print0)
fi

