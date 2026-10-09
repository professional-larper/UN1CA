
echo "Deleting base saiv"

rm -rf -- "$WORK_DIR/system/system/saiv/beauty"
rm -rf -- "$WORK_DIR/system/system/saiv/face"
rm -rf -- "$WORK_DIR/system/system/saiv/facerestoration"
rm -rf -- "$WORK_DIR/system/system/saiv/image_understanding"
rm -rf -- "$WORK_DIR/system/system/etc/saiv"

echo "Adding target saiv"

cp -r "$SRC_DIR/target/a70q/patches/saiv/system/"* "$WORK_DIR/system/system/"

echo "saiv was successfully patched"
