# RPi_3_b with slb9670 TPM, secure boot

Secure Boot generally means to boot the OS only if kernel files are not modified by external reasons such as virus, bad actor etc…

With a script we calculate the hash of kernel7.img and bcm2710-rpi-3-b.dtb and stores it to non volatile memory of TPM.

During boot the u-boot calculates the hash of kernel7.img and bcm2710-rpi-3-b.dtb and compares it with the one stored in NV memory of TPM. If they are the same then booting process is continued if not the booting proccess is halted. 

Read the Read_me.pdf for step by step instructions.
