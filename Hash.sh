echo "Clear TPM2 registry first"
sudo tpm2_pcrreset 23

SHA256_KERNEL=$(sha256sum /boot/kernel7.img | awk '{split($0,a," "); print a[1]}')
echo "Kernel Hash: $SHA256_KERNEL"
sudo tpm2_pcrextend 23:sha256=$SHA256_KERNEL
echo "Stage 1 PCR: Extending with Kernel"
sudo tpm2_pcrread sha256:23
echo

SHA256_FDT=$(sha256sum /boot/bcm2710-rpi-3-b.dtb | awk '{split($0,a," "); print a[1]}')
echo "FDT Hash: $SHA256_FDT"
sudo tpm2_pcrextend 23:sha256=$SHA256_FDT
echo "Stage 2 PCR: Extending with FDT"
sudo tpm2_pcrread sha256:23
echo

#echo "Save hash to NV memory at index 0x1800000"
SHA256=$(sudo tpm2_pcrread sha256:23 | awk '{split($0,a,"x"); print a[2]}') 
echo "Final hash to save"
echo $SHA256

#write hash to file
sudo echo $SHA256 > hash
#convert text file to binary
sudo xxd -r -p hash > hash.bin

sudo tpm2_nvundefine 0x1800000   #if previously defined then undefine
sudo tpm2_nvdefine 0x1800000 -C o -s 32 -a "ownerwrite|authwrite|ownerread|authread|ppread"
sudo tpm2_nvwrite 0x1800000 -C o -i hash.bin

echo "Hash saved to NV memory at 0x1800000 for platform hierarchy"
echo

echo "Clear again TPM2 PCR 23 registry "
sudo tpm2_pcrreset 23
