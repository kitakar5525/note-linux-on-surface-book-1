# Notes of Linux on Surface Book 1 with Performance Base
Notes to use Linux on Surface Book 1 with Performance Base. Maybe also useful to other devices.

Actual patches are here:
- [arch\-kernel\-linux\-lts419\-surface](https://github.com/kitakar5525/arch-kernel-linux-lts419-surface)
- [arch\-kernel\-linux\-surface](https://github.com/kitakar5525/arch-kernel-linux-surface)
- [arch\-kernel\-linux\-rc\-surface](https://github.com/kitakar5525/arch-kernel-linux-rc-surface)

Table of Contents
<!-- TOC -->

- [Notes of Linux on Surface Book 1 with Performance Base](#notes-of-linux-on-surface-book-1-with-performance-base)
    - [Working state](#working-state)
        - [What is working IF you configure settings or apply patch(es)](#what-is-working-if-you-configure-settings-or-apply-patches)
        - [What is working IF you apply patch(es) to kernel](#what-is-working-if-you-apply-patches-to-kernel)
        - [What is NOT working](#what-is-not-working)
    - [Suspend (s2idle) issues](#suspend-s2idle-issues)
        - [Observe s2idle issue](#observe-s2idle-issue)
        - [NVMe SSD not working after s2idle](#nvme-ssd-not-working-after-s2idle)
            - [References](#references)
            - [Memo: What I tried for NVMe which did not work](#memo-what-i-tried-for-nvme-which-did-not-work)
        - [Wi-Fi not working after s2idle](#wi-fi-not-working-after-s2idle)
        - [Power comsumption on s2idle](#power-comsumption-on-s2idle)
    - [Wi-Fi issues](#wi-fi-issues)
        - [Disable Wi-Fi power_save for stability](#disable-wi-fi-power_save-for-stability)
            - [Or apply patch to kernel](#or-apply-patch-to-kernel)
        - [Reset Wi-Fi in case of Wi-Fi crashing or malfunctioning](#reset-wi-fi-in-case-of-wi-fi-crashing-or-malfunctioning)
    - [Settings](#settings)
        - [Kernel parameters](#kernel-parameters)
        - [/usr/lib/systemd/system-sleep/sleep](#usrlibsystemdsystem-sleepsleep)
        - [wakeups](#wakeups)
    - [How to reach pc10 on power-on-idle](#how-to-reach-pc10-on-power-on-idle)
    - [/sys/module, useful to debug](#sysmodule-useful-to-debug)
    - [dGPU not working](#dgpu-not-working)
        - [\_SB_.PCI0.I2C0.SAM_](#\_sb_pci0i2c0sam_)

<!-- /TOC -->

## Working state

### What is working IF you configure settings or apply patch(es)

- suspend (s2idle): see [Suspend (s2idle) issues](#suspend-s2idle-issues)

### What is working IF you apply patch(es) to kernel

- Touch input: like touchscreen and pen.
    - Apply ipts patch from [jakeday repository](https://github.cpowerom/jakeday/linux-surface)

### What is NOT working

- S0ix state
    - Means power consumption is high on suspend (s2idle). See [Power comsumption on suspend (s2idle)](#power-comsumption-on-suspend-s2idle)
- Cameras
    - Issue tracked here: [Surface Pro 4 / 2017 and Books: Cameras are not working · Issue #145 · jakeday/linux-surface](https://github.com/jakeday/linux-surface/issues/145)
- dGPU
    - See [dGPU not working](#dgpu-not-working)
- Touch input (IPTS) sometimes crashes
    - But now the frequency is very low thanks to this [commit](https://github.com/jakeday/linux-surface/commit/1143fcaa6b40e6bd53adba8556789155572ef4fb#diff-42d706f8ccc685dafed2052309affbd7) in jakeday repository.
- Wi-Fi power_save
    - We need to disable power_save for stability for now. If we disable power_save, the stability is enough for daily usage. Disabling power_save is included in wifi patch of jakeday repository.

## Suspend (s2idle) issues
### Observe s2idle issue

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

For nvme, see [NVMe SSD not working after s2idle](#nvme-ssd-not-working-after-s2idle).
For wifi, see [Wi-Fi not working after s2idle](#wi-fi-not-working-after-s2idle).

### NVMe SSD not working after s2idle

if you have TOSHIBA NVMe disk, you may need to disable D3 state of NVMe disk

```bash
lspci -nn | grep -i toshiba
02:00.0 Non-Volatile memory controller [0108]: Toshiba America Info Systems NVMe Controller [1179:010f] (rev 01)

sudo smartctl -a /dev/nvme0 | grep -e "Model Number:" -e "Firmware Version:"
Model Number:                       THNSN5512GPU7 TOSHIBA
Firmware Version:                   57MS4109
```

then, disable D3 state of NVMe. There are two ways to disable D3 state:

```bash
echo 0 > "/sys/bus/pci/devices/0000:02:00.0/d3cold_allowed" # nvme
```

or, apply patches to kernel like this:
- [[v2,1/2] pci: prevent sk hynix nvme from entering D3 - Patchwork](https://lore.kernel.org/patchwork/patch/1007283/)

This is enough for just fix suspend resume, but because we disable the D3 state of NVMe, this is not power-efficient. You may want to apply like below patch, too:
- [[v2,2/2] nvme: add quirk to not call disable function when suspending - Patchwork](https://lore.kernel.org/patchwork/patch/1007284/)

#### References

I found a similar issue on another NVMe disk:
- [196907 – [Regression] s2idle does not work with PC300 NVMe SK hynix 512GB - Dell XPS 13 9360](https://bugzilla.kernel.org/show_bug.cgi?id=196907)
- [199689 – s2idle does not work in Dell XPS 9370](https://bugzilla.kernel.org/show_bug.cgi?id=199689)

#### Memo: What I tried for NVMe which did not work

- disabling Runtime PM for NVMe disk: `echo "on" > "/sys/devices/pci0000:00/0000:00:1d.0/0000:02:00.0/power/control"`
- disabling APST
    - set `nvme_core.default_ps_max_latency_us=0` to bootloader, or
    - `NVME_QUIRK_NO_APST`
- `NVME_QUIRK_DELAY_BEFORE_CHK_RDY`
- `NVME_QUIRK_NO_DEEPEST_PS`

### Wi-Fi not working after s2idle

You can simply disable D3 state of Wi-Fi: `echo 0 > "/sys/bus/pci/devices/0000:03:00.0/d3cold_allowed" # wifi`, or apply patch to disable D3.

However, I think this is not power-efficient. I suggest that we just leave Wi-Fi to D3 and after suspend, reset Wi-Fi to wake it up. See [Reset Wi-Fi in case of Wi-Fi crashing or malfunctioning](#reset-wi-fi-in-case-of-wi-fi-crashing-or-malfunctioning) and [/usr/lib/systemd/system-sleep/sleep](#usrlibsystemdsystem-sleepsleep).

### Power comsumption on s2idle

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

## Wi-Fi issues
### Disable Wi-Fi power_save for stability

Edit `/etc/NetworkManager/NetworkManager.conf`
```bash
[connection]
# Values are 0 (use default), 1 (ignore/don't touch), 2 (disable) or 3 (enable).
# [NetworkManager Wi-Fi powersaving configuration](https://gist.github.com/jcberthon/ea8cfe278998968ba7c5a95344bc8b55)
wifi.powersave = 2
```

or this (not persistent across reboots)
```bash
# wlp3s0 maybe different. Find it by `ip addr`
sudo iw dev wlp3s0 set power_save off
```

#### Or apply patch to kernel

Apply wifi patch of jakeday repository

### Reset Wi-Fi in case of Wi-Fi crashing or malfunctioning

It is stable enough if you apply wifi patch from jakeday repo. But in case of Wi-Fi crashing or malfunctioning, you can reset Wi-Fi.

`RP12` can differ if you use another Surface device. [Disassemble](https://wiki.archlinux.org/index.php/DSDT#Recompiling_it_yourself) your DSDT table and try to search `_RST` first.

- Requires [acpi_call](https://github.com/mkottman/acpi_call)

```bash
# Reset Wi-Fi
echo '\_SB.PCI0.RP12.PXSX.PRWF._RST' > /proc/acpi/call
echo 1 > "/sys/bus/pci/devices/0000:00:1d.3/remove"
sleep 1
echo 1 > /sys/bus/pci/rescan
sleep 1
```

It seems that once we issue `echo '\_SB.PCI0.RP12.PXSX.PRWF._OFF' > /proc/acpi/call`, then we cannot wakeup wifi again.

## Settings

### Kernel parameters

- i915.enable_psr=1
- i915.fastboot=1
- i915.enable_guc=-1
- nvme_core.default_ps_max_latency_us=170000

You can see parameters value of a module by: `sudo systool -m i915 -v`. Parameters explanations: `modinfo i915`. For non-modules: `tail /sys/module/nvme_core/parameters/*`.

### /usr/lib/systemd/system-sleep/sleep

```bash
#!/bin/sh

case $1/$2 in
  pre/*)
    echo disabled > "/sys/devices/pci0000:00/0000:00:14.0/power/wakeup" # XHC
    echo disabled > "/sys/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.4/power/wakeup" # Surface Keyboard
    echo disabled > "/sys/devices/pci0000:00/0000:00:14.0/usb1/1-6/power/wakeup" # Bluetooth and Wireless LAN Composite Device
    #echo enabled > "/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/power/wakeup" # LID0

    echo 1 > /sys/power/pm_debug_messages
    echo 0 > /sys/module/printk/parameters/console_suspend
    echo 1 > /sys/module/printk/parameters/ignore_loglevel
    #echo 1 > /sys/module/acpi/parameters/ec_no_wakeup
    #sysctl kernel.resume_delay=2000
    #echo 1 > /sys/module/mwifiex/parameters/disconnect_on_suspend

    modprobe -r intel_ipts
    modprobe -r mei_me
    modprobe -r mei
    ;;
  post/*)
    # Reset Wi-Fi
    echo '\_SB.PCI0.RP12.PXSX.PRWF._RST' > /proc/acpi/call
    echo 1 > "/sys/bus/pci/devices/0000:00:1d.3/remove"
    sleep 1
    echo 1 > /sys/bus/pci/rescan
    sleep 1
    echo disabled > "/sys/devices/pci0000:00/0000:00:1d.3/power/wakeup" # RP12
    
    modprobe -i intel_ipts
    modprobe -i mei_me
    modprobe -i mei

    echo 0 > /sys/module/printk/parameters/ignore_loglevel
    ;;
esac
```

### wakeups

Configure which wakeup source to allow wakeup from suspend.

For some reasons we cannot enable or disable wakeup from peripheral devices like lid, keyboard or bluetooth from [/proc/acpi/wakeup](/proc_acpi_wakeup.md).

```bash
sudo find / -name wakeup
/sys/kernel/irq/136/wakeup
[...]
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
/sys/devices/pci0000:00/0000:00:14.0/usb1/power/wakeup # xHCI Host Controller
/sys/devices/pci0000:00/0000:00:14.0/usb1/1-1/power/wakeup # USB2.0 Hub
/sys/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.4/power/wakeup # Surface Keyboard
/sys/devices/pci0000:00/0000:00:14.0/usb1/1-6/power/wakeup # USB 1-6 (Bluetooth and Wireless LAN Composite Device)
/sys/devices/pci0000:00/0000:00:14.0/power/wakeup # XHC
/sys/devices/pci0000:00/0000:00:14.0/usb2/2-1/power/wakeup # USB3.0 Hub
/sys/devices/pci0000:00/0000:00:14.0/usb2/power/wakeup # xHCI Host Controller
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

For example, you can disable wakeup from XHC, which sometimes wakes up my Surface unintentionally:

```bash
echo disabled > "/sys/devices/pci0000:00/0000:00:14.0/power/wakeup" # XHC
```

You can find which device is enabled for wakeup:

```bash
tail $(sudo find /sys -name wakeup) | grep enabled -n1
tail: cannot open '/sys/kernel/debug/tracing/events/ftrace/wakeup' for reading: Permission denied
181-==> /sys/devices/pci0000:00/0000:00:14.0/usb1/power/wakeup <==
182:enabled
183-
184-==> /sys/devices/pci0000:00/0000:00:14.0/usb1/1-1/power/wakeup <==
185:enabled
186-
187-==> /sys/devices/pci0000:00/0000:00:14.0/usb1/1-1/1-1.4/power/wakeup <==
188:enabled
189-
--
193-==> /sys/devices/pci0000:00/0000:00:14.0/power/wakeup <==
194:enabled
195-
--
214-==> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:19/PNP0C09:00/MSHW0040:00/power/wakeup <==
215:enabled
```

## How to reach pc10 on power-on-idle

- 4.20.1-arch1-1-surface

```bash
# stop Wi-Fi and Bluetooth
rfkill block wlan
rfkill block bluetooth

# remove Wi-Fi
sudo su -c "echo 1 > "/sys/bus/pci/devices/0000:03:00.0/remove""
```

to reach `Pk%pc10` and `CPU%LPI` on power-on-idle. You can watch residency with `sudo turbostat`

You can rescan PCI devices to use Wi-Fi again:
```bash
sudo su -c "echo 1 > /sys/bus/pci/rescan"

# then
rfkill unblock wlan
rfkill unblock bluetooth
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
