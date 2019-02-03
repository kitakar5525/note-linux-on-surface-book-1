# Notes of Linux on Surface devices
Notes to use Linux on Surface devices (especially on Surface Book 1 and Surface 3)

Device specific notes is here:
- [Surface Book with Performance Base specific](/Surface-Book-with-Performance-Base-specific.md)
- [Surface 3 specific](/Surface-3-specific.md)

Table of Contents
<!-- TOC -->

- [note-linux-on-surface-devices](#note-linux-on-surface-devices)
  - [Observe suspend (s2idle) issue](#observe-suspend-s2idle-issue)
  - [resume from suspend (s2idle)](#resume-from-suspend-s2idle)
    - [Or apply patches to kernel](#or-apply-patches-to-kernel)
  - [Power comsumption on suspend (s2idle)](#power-comsumption-on-suspend-s2idle)
  - [Marvell wifi remove and pc10 on power-on-idle](#marvell-wifi-remove-and-pc10-on-power-on-idle)
  - [/usr/lib/systemd/system-sleep/sleep](#usrlibsystemdsystem-sleepsleep)
  - [/sys/module, useful to debug](#sysmodule-useful-to-debug)
  - [wakeups](#wakeups)

<!-- /TOC -->

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

## resume from suspend (s2idle)

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

## Marvell wifi remove and pc10 on power-on-idle

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
