# RPi_3_b-and-slb9670_TPM-secure-boot
Secure Boot a Raspberry Pi 3 B, with u-boot and slb9670 infenion TPM2

We need a Raspberry Pi 3 B with raspbian OS, a TPM2 slb9670 Infenion and U-boot as second bootloader.
U-boot on a RPi 3 B, cannot communicate with TPM slb9670, during boot. 
So new code added to u-boot/arch/arm/dts/bcm2837-rpi-3-b.dts.
Also code added to u-boot/cmd/tpm-v2.c, so that u-boot could read non volatile memmory of slb9670 during boot.

Lets assume we have a working Raspberry Pi 3 B with Raspbian OS and a Infenion TPM slb9670 connected to SPI port.
First we have add to conig.txt three commands
dtparam=spi=on
kernel=u-boot.bin
dtoverlay=tpm-slb9670

Then we must install the TPM framework, so that the OS can communicate with TPM.
first we make an update and then install the dependecies
sudo apt-get update 
sudo apt-get upgrade 
sudo apt-get –y install \
autoconf-archive \ 
libcmocka0 \ 
libcmocka-dev \ 
procps \ 
iproute2 \ 
build-essential \ 
git \ 
pkg-config \ 
gcc \ 
libtool \ 
automake \ 
libssl-dev \ 
uthash-dev \ 
autoconf \ 
doxygen \ 
libjson-c-dev \ 
libini-config-dev \ 
libcurl4-openssl-dev \
U-boot sudo apt-get \
uuid-dev \ 
pandoc \ 
bison \ 
flex \ 
libncurses-dev

for the TPM framework
git clone https://github.com/tpm2-software/tpm2-tss ~/tpm2-tss
cd ~/tpm2-tss 
sudo ./bootstrap 
sudo ./configure 
sudo make -j$(nproc) 
sudo make install 
sudo ldconfig

git clone https://github.com/tpm2-software/tpm2-tss-engine ~/tpm2-tss-engine
cd ~/tpm2-tss-engine 
sudo ./bootstrap 
sudo ./configure 
sudo make -j$(nproc) 
sudo make install 
sudo ldconfig

git clone https://github.com/tpm2-software/tpm2-tools ~/tpm2-tools 
cd ~/tpm2-tools 
sudo ./bootstrap 
sudo ./configure 
sudo make -j$(nproc) 
sudo make install 
sudo ldconfig


We compile the device tree for tpm the "tpm-slb9670.dts"
dtc -@ -I dts -O dtb -o tpm-slb9670.dtbo tpm-slb9670.dts
and finaly add the compiled file "tpm-slb9670.dtbo" to dtoverlay dir

