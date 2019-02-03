# Surface Book with Performance Base specific

- What is not working
  - S0ix state
    - Means power consumption is high on suspend (s2idle). But s2idle is working.
  - Cameras
  - dGPU

## USB devices

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

## PCI devices

```bash
lspci -nn
00:00.0 Host bridge [0600]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Host Bridge/DRAM Registers [8086:1904] (rev 08)
00:02.0 VGA compatible controller [0300]: Intel Corporation Skylake GT2 [HD Graphics 520] [8086:1916] (rev 07)
00:05.0 Multimedia controller [0480]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Imaging Unit [8086:1919] (rev 01)
00:08.0 System peripheral [0880]: Intel Corporation Xeon E3-1200 v5/v6 / E3-1500 v5 / 6th/7th Gen Core Processor Gaussian Mixture Model [8086:1911]
00:14.0 USB controller [0c03]: Intel Corporation Sunrise Point-LP USB 3.0 xHCI Controller [8086:9d2f] (rev 21)
00:14.2 Signal processing controller [1180]: Intel Corporation Sunrise Point-LP Thermal subsystem [8086:9d31] (rev 21)
00:14.3 Multimedia controller [0480]: Intel Corporation Device [8086:9d32] (rev 01)
00:15.0 Signal processing controller [1180]: Intel Corporation Sunrise Point-LP Serial IO I2C Controller #0 [8086:9d60] (rev 21)
00:15.1 Signal processing controller [1180]: Intel Corporation Sunrise Point-LP Serial IO I2C Controller #1 [8086:9d61] (rev 21)
00:15.2 Signal processing controller [1180]: Intel Corporation Sunrise Point-LP Serial IO I2C Controller #2 [8086:9d62] (rev 21)
00:15.3 Signal processing controller [1180]: Intel Corporation Sunrise Point-LP Serial IO I2C Controller #3 [8086:9d63] (rev 21)
00:16.0 Communication controller [0780]: Intel Corporation Sunrise Point-LP CSME HECI #1 [8086:9d3a] (rev 21)
00:16.4 Communication controller [0780]: Intel Corporation Device [8086:9d3e] (rev 21)
00:1c.0 PCI bridge [0604]: Intel Corporation Sunrise Point-LP PCI Express Root Port #5 [8086:9d14] (rev f1)
00:1d.0 PCI bridge [0604]: Intel Corporation Sunrise Point-LP PCI Express Root Port #9 [8086:9d18] (rev f1)
00:1d.3 PCI bridge [0604]: Intel Corporation Device [8086:9d1b] (rev f1)
00:1f.0 ISA bridge [0601]: Intel Corporation Sunrise Point-LP LPC Controller [8086:9d48] (rev 21)
00:1f.2 Memory controller [0580]: Intel Corporation Sunrise Point-LP PMC [8086:9d21] (rev 21)
00:1f.3 Audio device [0403]: Intel Corporation Sunrise Point-LP HD Audio [8086:9d70] (rev 21)
02:00.0 Non-Volatile memory controller [0108]: Toshiba America Info Systems NVMe Controller [1179:010f] (rev 01)
03:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 88W8897 [AVASTAR] 802.11ac Wireless [11ab:2b38]
```

```bash
lspci -nnvt
-[0000:00]-+-00.0  Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Host Bridge/DRAM Registers [8086:1904]
           +-02.0  Intel Corporation Skylake GT2 [HD Graphics 520] [8086:1916]
           +-05.0  Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Imaging Unit [8086:1919]
           +-08.0  Intel Corporation Xeon E3-1200 v5/v6 / E3-1500 v5 / 6th/7th Gen Core Processor Gaussian Mixture Model [8086:1911]
           +-14.0  Intel Corporation Sunrise Point-LP USB 3.0 xHCI Controller [8086:9d2f]
           +-14.2  Intel Corporation Sunrise Point-LP Thermal subsystem [8086:9d31]
           +-14.3  Intel Corporation Device [8086:9d32]
           +-15.0  Intel Corporation Sunrise Point-LP Serial IO I2C Controller #0 [8086:9d60]
           +-15.1  Intel Corporation Sunrise Point-LP Serial IO I2C Controller #1 [8086:9d61]
           +-15.2  Intel Corporation Sunrise Point-LP Serial IO I2C Controller #2 [8086:9d62]
           +-15.3  Intel Corporation Sunrise Point-LP Serial IO I2C Controller #3 [8086:9d63]
           +-16.0  Intel Corporation Sunrise Point-LP CSME HECI #1 [8086:9d3a]
           +-16.4  Intel Corporation Device [8086:9d3e]
           +-1c.0-[01]--
           +-1d.0-[02]----00.0  Toshiba America Info Systems NVMe Controller [1179:010f]
           +-1d.3-[03]----00.0  Marvell Technology Group Ltd. 88W8897 [AVASTAR] 802.11ac Wireless [11ab:2b38]
           +-1f.0  Intel Corporation Sunrise Point-LP LPC Controller [8086:9d48]
           +-1f.2  Intel Corporation Sunrise Point-LP PMC [8086:9d21]
           \-1f.3  Intel Corporation Sunrise Point-LP HD Audio [8086:9d70]
```

Maybe dGPU is connected to `00:1c.0`.

## dGPU not working

Issue tracked here:
- [[SB w Performance Base] `lspci` doesn't show Nvidia 965M graphics card · Issue #286 · jakeday/linux-surface](https://github.com/jakeday/linux-surface/issues/286)

### \_SB_.PCI0.I2C0.SAM_

```bash
tail /sys/bus/i2c/devices/i2c-MSHW0030:00/firmware_node/path
\_SB_.PCI0.I2C0.SAM_
```

- `/sys/bus/i2c/devices/i2c-5/i2c-MSHW0030:00/`
- `sudo modprobe i2c-dev`

- [mkottman/acpi_call: A linux kernel module that enables calls to ACPI methods through /proc/acpi/call. Now with support for Integer, String and Buffer parameters.](https://github.com/mkottman/acpi_call)
```bash
echo '\_SB.PCI0.RP05.HGON' > /proc/acpi/call
kern  :warn  : [ +42.597418] i2c i2c-5: protocol 0x0e not supported for client 0x28
kern  :err   : [  +0.000006] ACPI Exception: AE_BAD_PARAMETER, Returned by Handler for [GenericSerialBus] (20170728/evregion-300)
kern  :err   : [  +0.000020] ACPI Error: Result stack is empty! State=ffff88d4a417d400 (20170728/dswstate-99)
kern  :err   : [  +0.000018] ACPI Error: Method parse/execution failed \_SB.PCI0.I2C0.SAM.SCMD, AE_BAD_PARAMETER (20170728/psparse-550)
kern  :err   : [  +0.000015] ACPI Error: Method parse/execution failed \_SB.PCI0.RP05.HGON, AE_BAD_PARAMETER (20170728/psparse-550)
kern  :err   : [  +0.000017] acpi_call: Method call failed: Error: AE_BAD_PARAMETER
```