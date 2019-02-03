# note-linux-on-surface-devices
Notes to use Linux on Surface devices (especially on Surface Book 1 and Surface 3)

## Observe suspend (s2idle) issue

```bash
echo 1 > /sys/power/pm_debug_messages
echo 0 > /sys/module/printk/parameters/console_suspend
echo 1 > /sys/module/printk/parameters/ignore_loglevel
```

and go into suspend. If you see like this:

```bash
pci 0000:03:00.0: Refused to change power state, currently in D3
nvme 0000:02:00.0: Refused to change power state, currently in D3
```

then, go to next section.

## resume from suspend (s2idle) (SB1 with Performance Base)

if you have TOSHIBA NVMe disk, you may need to disable D3 state of NVMe disk

```bash
lspci -nn | grep -i toshiba
02:00.0 Non-Volatile memory controller [0108]: Toshiba America Info Systems NVMe Controller [1179:010f] (rev 01)

sudo smartctl -a /dev/nvme0 | grep -e "Model Number:" -e "Firmware Version:"
Model Number:                       THNSN5512GPU7 TOSHIBA
Firmware Version:                   57MS4109
```

then, disable D3 state of NVMe and WIFI

```bash
echo 0 > "/sys/bus/pci/devices/0000:02:00.0/d3cold_allowed" # nvme
echo 0 > "/sys/bus/pci/devices/0000:03:00.0/d3cold_allowed" # wifi
```

### Or apply patches to kernel

I found a similar issue on another NVMe disk:
- [196907 – [Regression] s2idle does not work with PC300 NVMe SK hynix 512GB - Dell XPS 13 9360](https://bugzilla.kernel.org/show_bug.cgi?id=196907)
- [199689 – s2idle does not work in Dell XPS 9370](https://bugzilla.kernel.org/show_bug.cgi?id=199689)

patches here:

- [[v2,1/2] pci: prevent sk hynix nvme from entering D3 - Patchwork](https://lore.kernel.org/patchwork/patch/1007283/)
- [[v2,2/2] nvme: add quirk to not call disable function when suspending - Patchwork](https://lore.kernel.org/patchwork/patch/1007284/)

## Power comsumption on suspend (s2idle)

Documentation from Intel:
- [How to achieve S0ix states in Linux* | 01.org](https://01.org/blogs/qwang59/2018/how-achieve-s0ix-states-linux)

We can reach pc10 on s2idle, you can observe it by `watch -n1 sudo turbostat -s Pkg%pc2,Pkg%pc3,Pkg%pc6,Pkg%pc7,Pkg%pc8,Pkg%pc9,Pk%pc10,CPU%LPI,SYS%LPI -q` or `cat /sys/devices/system/cpu/cpuidle/low_power_idle_cpu_residency_us`, but we cannot enter s0ix yet.

```bash
sudo cat /sys/kernel/debug/pmc_core/slp_s0_residency_usec
0
```

There are some patches to improve power consumption on s2idle:
- from [196907 – [Regression] s2idle does not work with PC300 NVMe SK hynix 512GB - Dell XPS 13 9360](https://bugzilla.kernel.org/show_bug.cgi?id=196907)
	- [[v2,2/2] nvme: add quirk to not call disable function when suspending - Patchwork](https://lore.kernel.org/patchwork/patch/1007284/)
- from [201579 – HP Elite x2 1013 G3 unable to enter S0ix](https://bugzilla.kernel.org/show_bug.cgi?id=201579)
	- [[1/1] ipu3-cio2: Allow probe to succeed if there are no sensors connected - Patchwork](https://patchwork.kernel.org/patch/10714257/)
	- [x86 platform driver layer - Patchwork](https://patchwork.kernel.org/project/platform-driver-x86/list/?series=74547)

## Marvell wifi remove and rescan and pc10 on power-on-idle

- 4.20.1-arch1-1-surface

```bash
# stop WIFI and Bluetooth
rfkill block wlan
rfkill block bluetooth

# remove WIFI
sudo su -c "echo 1 > "/sys/bus/pci/devices/0000:03:00.0/remove""
```

to reach `Pk%pc10` and `CPU%LPI` on power-on-idle. You can watch residency with `sudo turbostat`

You can rescan PCI devices to use WIFI again:
```bash
sudo su -c "echo 1 > /sys/bus/pci/rescan"

# then
rfkill unblock wlan
rfkill unblock bluetooth
```

## /usr/lib/systemd/system-sleep/sleep

```bash
#!/bin/sh

case $1/$2 in
  pre/*)
    echo 1 > /sys/power/pm_debug_messages
    echo 0 > /sys/module/printk/parameters/console_suspend
    echo 1 > /sys/module/printk/parameters/ignore_loglevel

    modprobe -r intel_ipts
    modprobe -r mei_me
    modprobe -r mei
    ;;
  post/*)
    modprobe -i intel_ipts
    modprobe -i mei_me
    modprobe -i mei

    modprobe -r mwifiex_pcie
    modprobe -i mwifiex_pcie

    echo 0 > /sys/module/printk/parameters/ignore_loglevel
    ;;
esac
```

## /sys/module, useful to debug

```bash
echo 1 > /sys/module/printk/parameters/ignore_loglevel
echo 0 > /sys/module/printk/parameters/console_suspend

echo 0xFFFFFFFF > /sys/module/acpi/parameters/debug_layer
echo 0x00000002 > /sys/module/acpi/parameters/debug_level

echo 170000 > /sys/module/nvme_core/parameters/default_ps_max_latency_us
echo 1 > /sys/module/acpi/parameters/ec_no_wakeup
echo 0x02 > /sys/module/drm/parameters/debug

# read-only
cat /sys/module/acpiphp/parameters/disable
cat /sys/module/i915/parameters/disable_power_well
cat /sys/module/i915/parameters/enable_dc
```

## wakeups

Configure which device to allow wakeup from suspend.

```bash
sudo find / -name wakeup
/sys/kernel/irq/136/wakeup
/sys/kernel/irq/17/wakeup
/sys/kernel/irq/126/wakeup
/sys/kernel/irq/7/wakeup
/sys/kernel/irq/144/wakeup
/sys/kernel/irq/134/wakeup
/sys/kernel/irq/15/wakeup
/sys/kernel/irq/124/wakeup
/sys/kernel/irq/5/wakeup
/sys/kernel/irq/142/wakeup
/sys/kernel/irq/132/wakeup
/sys/kernel/irq/13/wakeup
/sys/kernel/irq/122/wakeup
/sys/kernel/irq/3/wakeup
/sys/kernel/irq/140/wakeup
/sys/kernel/irq/130/wakeup
/sys/kernel/irq/11/wakeup
/sys/kernel/irq/120/wakeup
/sys/kernel/irq/1/wakeup
/sys/kernel/irq/139/wakeup
/sys/kernel/irq/86/wakeup
/sys/kernel/irq/129/wakeup
/sys/kernel/irq/137/wakeup
/sys/kernel/irq/18/wakeup
/sys/kernel/irq/127/wakeup
/sys/kernel/irq/8/wakeup
/sys/kernel/irq/145/wakeup
/sys/kernel/irq/135/wakeup
/sys/kernel/irq/16/wakeup
/sys/kernel/irq/125/wakeup
/sys/kernel/irq/6/wakeup
/sys/kernel/irq/143/wakeup
/sys/kernel/irq/133/wakeup
/sys/kernel/irq/14/wakeup
/sys/kernel/irq/123/wakeup
/sys/kernel/irq/4/wakeup
/sys/kernel/irq/141/wakeup
/sys/kernel/irq/131/wakeup
/sys/kernel/irq/12/wakeup
/sys/kernel/irq/121/wakeup
/sys/kernel/irq/2/wakeup
/sys/kernel/irq/10/wakeup
/sys/kernel/irq/0/wakeup
/sys/kernel/irq/138/wakeup
/sys/kernel/irq/19/wakeup
/sys/kernel/irq/128/wakeup
/sys/kernel/irq/9/wakeup
/sys/kernel/debug/tracing/events/ftrace/wakeup
/sys/devices/pnp0/00:03/power/wakeup # required for rtcwake
/sys/devices/platform/serial8250/tty/ttyS2/power/wakeup
/sys/devices/platform/serial8250/tty/ttyS0/power/wakeup
/sys/devices/platform/serial8250/tty/ttyS3/power/wakeup
/sys/devices/platform/serial8250/tty/ttyS1/power/wakeup
/sys/devices/pci0000:00/0000:00:1c.0/power/wakeup
/sys/devices/pci0000:00/0000:00:1d.3/0000:03:00.0/power/wakeup
/sys/devices/pci0000:00/0000:00:1d.3/power/wakeup # RP12
/sys/devices/pci0000:00/0000:00:16.4/power/wakeup
/sys/devices/pci0000:00/0000:00:16.0/power/wakeup
/sys/devices/pci0000:00/0000:00:1f.3/power/wakeup
/sys/devices/pci0000:00/0000:00:1d.0/0000:02:00.0/power/wakeup
/sys/devices/pci0000:00/0000:00:1d.0/power/wakeup # RP09
/sys/devices/pci0000:00/0000:00:14.0/usb1/power/wakeup
/sys/devices/pci0000:00/0000:00:14.0/usb1/1-1/power/wakeup
/sys/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.4/power/wakeup
/sys/devices/pci0000:00/0000:00:14.0/usb1/1-6/power/wakeup # USB 1-6 (Bluetooth and Wireless LAN Composite Device)
/sys/devices/pci0000:00/0000:00:14.0/power/wakeup # XHC
/sys/devices/pci0000:00/0000:00:14.0/usb2/2-1/power/wakeup
/sys/devices/pci0000:00/0000:00:14.0/usb2/power/wakeup
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/power/wakeup # LID0
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:19/PNP0C09:00/PNP0C0A:00/power/wakeup # BAT1
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:19/PNP0C09:00/ACPI0003:00/power_supply/ADP1/power/wakeup # ADP1
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:19/PNP0C09:00/PNP0C0A:01/power/wakeup # BAT2
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:19/PNP0C09:00/MSHW0040:00/power/wakeup # Power button
find: ‘/run/user/1000/doc’: Permission denied
find: ‘/run/user/1000/gvfs’: Permission denied
/proc/acpi/wakeup
```

You can find which is which:

```bash
cat /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:19/PNP0C09:00/MSHW0040:00/path
\_SB_.PCI0.LPCB.EC0_.VGBI
```

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
