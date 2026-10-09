
echo "Deleting base cameradata"

rm -rf -- "$WORK_DIR/system/system/cameradata/portrait_data"
rm -rf -- "$WORK_DIR/system/system/cameradata/singletake"
rm -f -- "$WORK_DIR/system/system/cameradata/aremoji-feature.xml"
rm -f -- "$WORK_DIR/system/system/cameradata/camera-feature.xml"
rm -f -- "$WORK_DIR/system/system/cameradata/masking_roundrect_shape.png"
rm -f -- "$WORK_DIR/system/system/cameradata/masking_roundrect_shape_ninepatch.png"

echo "Adding target cameradata"

cp -r "$SRC_DIR/target/a70q/patches/cameradata/system/cameradata" "$WORK_DIR/system/system/"

echo "Fix AI Photo Editor"

cp -a --preserve=all \
    "$WORK_DIR/system/system/cameradata/portrait_data/single_bokeh_feature.json" \
    "$WORK_DIR/system/system/cameradata/portrait_data/unica_bokeh_feature.json"

SET_METADATA "system" "system/cameradata/portrait_data/unica_bokeh_feature.json" 0 0 644 "u:object_r:system_file:s0"

sed -i "s/MODEL_TYPE_INSTANCE_CAPTURE/MODEL_TYPE_OBJ_INSTANCE_CAPTURE/g" \
    "$WORK_DIR/system/system/cameradata/portrait_data/single_bokeh_feature.json"

sed -i \
    's/system\/cameradata\/portrait_data\/single_bokeh_feature.json/system\/cameradata\/portrait_data\/unica_bokeh_feature.json\x00/g' \
    "$WORK_DIR/system/system/lib64/libPortraitSolution.camera.samsung.so"

echo "cameradata was successfully patched!"

