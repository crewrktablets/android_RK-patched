#/bin/sh

# make a new system.img

rm ../out/system.img
dd if=/dev/zero of=../out/system.img bs=1024 count=610000
mkfs.ext3 ../out/system.img


# copy the files to the new system.img

mkdir -p /tmp/system
sudo mount ../out/system.img /tmp/system
sudo rm -r /tmp/system/*
sudo cp -r --preserve ../out/target/product/rk31board/system/* /tmp/system
sudo rm /tmp/system/app/CMAccount.apk
sudo mv /tmp/system/lib/hw/hwcomposer.rk30board.so /tmp/system/lib/hw/hwcomposer.rk30board.so.org
sudo chown root:root -R /tmp/system
sudo chmod 06755 /tmp/system/xbin/su
sudo chmod 04755 /tmp/system/bin/usb_modeswitch
sudo chmod 04755 /tmp/system/bin/usb_modeswitch.sh
sudo chmod 00755 /tmp/system/etc/ppp/ip-up
sudo chmod 00755 /tmp/system/etc/ppp/ip-down
sudo chmod 00755 /tmp/system/etc/ppp/call-pppd
sudo chmod 00755 /tmp/system/bin/sysinit
sudo umount /tmp/system
rm -r /tmp/system


# make boot.img and copy to the same direktory as system.img

rm ../out/boot.img
pushd ../out/target/product/rk31board/root/
chmod g-w -R *
find . | cpio -o -H newc | gzip -n > ../../../../boot.gz
popd

cd ../out/target/product/rk31board/rktools
./rkcrc -k ../../../../boot.gz ../../../../boot.img

rm ../../../../boot.gz

exit 0
