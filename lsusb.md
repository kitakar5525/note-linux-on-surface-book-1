# lsusb

```bash
lsusb
Bus 002 Device 002: ID 045e:090b Microsoft Corp. Hub # 2-1, USB3.0 Hub
Bus 002 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub # usb2, xHCI Host Controller
Bus 001 Device 004: ID 1286:204c Marvell Semiconductor, Inc. # 1-6, Bluetooth and Wireless LAN Composite Device
Bus 001 Device 003: ID 045e:07ce Microsoft Corp. # 1-1.4, Surface Keyboard
Bus 001 Device 002: ID 045e:091a Microsoft Corp. Hub # 1-1, USB2.0 Hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub # usb1, xHCI Host Controller
```

```bash
tail /sys/bus/usb/devices/*/product
==> /sys/bus/usb/devices/1-1.4/product <==
Surface Keyboard

==> /sys/bus/usb/devices/1-1/product <==
USB2.0 Hub

==> /sys/bus/usb/devices/1-6/product <==
Bluetooth and Wireless LAN Composite Device

==> /sys/bus/usb/devices/2-1/product <==
USB3.0 Hub

==> /sys/bus/usb/devices/usb1/product <==
xHCI Host Controller

==> /sys/bus/usb/devices/usb2/product <==
xHCI Host Controller
```