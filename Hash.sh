echo "Clear TPM2 registry first"
sudo tpm2_pcrreset 23

SHA256_BOOT=$(sha256sum /boot/boot.scr.uimg | awk '{split($0,a," "); print a[1]}')
echo "Boot.scr: $SHA256_BOOT"
sudo tpm2_pcrextend 23:sha256=$SHA256_BOOT
echo "Stage 1 PCR: Extending with boot.scr"
sudo tpm2_pcrread sha256:23
echo

SHA256_TFTP=$(sha256sum /boot/tftp.scr.uimg | awk '{split($0,a," "); print a[1]}')
echo "tftp.scr: $SHA256_TFTP"
sudo tpm2_pcrextend 23:sha256=$SHA256_TFTP
echo "Stage 2 PCR: Extending with tftp.scr"
sudo tpm2_pcrread sha256:23
echo

SHA256_UBOOT=$(sha256sum /boot/u-boot.bin | awk '{split($0,a," "); print a[1]}')
echo "U Boot Hash: $SHA256_UBOOT"
sudo tpm2_pcrextend 23:sha256=$SHA256_UBOOT
echo "Stage 3 PCR: Extending with Bootloader"
sudo tpm2_pcrread sha256:23
echo

SHA256_KERNEL=$(sha256sum /boot/kernel7.img | awk '{split($0,a," "); print a[1]}')
echo "Kernel Hash: $SHA256_KERNEL"
sudo tpm2_pcrextend 23:sha256=$SHA256_KERNEL
echo "Stage 4 PCR: Extending with Kernel"
sudo tpm2_pcrread sha256:23
echo

SHA256_FDT=$(sha256sum /boot/bcm2710-rpi-3-b.dtb | awk '{split($0,a," "); print a[1]}')
echo "FDT Hash: $SHA256_FDT"
sudo tpm2_pcrextend 23:sha256=$SHA256_FDT
echo "Stage 5 PCR: Extending with FDT"
sudo tpm2_pcrread sha256:23
echo

SHA256_CONFIG=$(sha256sum /boot/config.txt | awk '{split($0,a," "); print a[1]}')
echo "Config Hash: $SHA256_CONFIG"
sudo tpm2_pcrextend 23:sha256=$SHA256_CONFIG
echo "Stage 6 PCR: Extending with Config"
echo ""

SHA256_TPM=$(sha256sum /boot/overlays/tpm-slb9670.dtbo | awk '{split($0,a," "); print a[1]}')
echo "TPM Hash: $SHA256_TPM"
sudo tpm2_pcrextend 23:sha256=$SHA256_TPM
echo "Stage 7 PCR: Extending with tpm-slb9670.dtbo"
echo ""

#echo "Save hash to NV memory at index 0x1800000"
SHA256=$(sudo tpm2_pcrread sha256:23 | awk '{split($0,a,"x"); print a[2]}') 
echo "Final hash to save"
echo $SHA256

#write hash to file
sudo echo $SHA256 > hash
#convert text file to binary
sudo xxd -r -p hash > hash.bin

sudo tpm2_nvundefine 0x1800000
sudo tpm2_nvdefine 0x1800000 -C o -s 32 -a "ownerwrite|authwrite|ownerread|authread|ppread"
sudo tpm2_nvwrite 0x1800000 -C o -i hash.bin

echo "Hash saved to NV memory at 0x1800000 for platform hierarchy"
echo

echo "Clear again TPM2 PCR 23 registry "
sudo tpm2_pcrreset 23
