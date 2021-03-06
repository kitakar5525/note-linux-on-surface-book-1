```
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

```
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

```
lspci -nnk
00:00.0 Host bridge [0600]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Host Bridge/DRAM Registers [8086:1904] (rev 08)
	Subsystem: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Host Bridge/DRAM Registers [8086:2015]
	Kernel driver in use: skl_uncore
00:02.0 VGA compatible controller [0300]: Intel Corporation Skylake GT2 [HD Graphics 520] [8086:1916] (rev 07)
	Subsystem: Microsoft Corporation Skylake GT2 [HD Graphics 520] [1414:0014]
	Kernel driver in use: i915
	Kernel modules: i915
00:05.0 Multimedia controller [0480]: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Imaging Unit [8086:1919] (rev 01)
	Subsystem: Intel Corporation Xeon E3-1200 v5/E3-1500 v5/6th Gen Core Processor Imaging Unit [8086:2015]
	Kernel driver in use: ipu3-imgu
	Kernel modules: ipu3_imgu
00:08.0 System peripheral [0880]: Intel Corporation Xeon E3-1200 v5/v6 / E3-1500 v5 / 6th/7th Gen Core Processor Gaussian Mixture Model [8086:1911]
	Subsystem: Intel Corporation Xeon E3-1200 v5/v6 / E3-1500 v5 / 6th/7th Gen Core Processor Gaussian Mixture Model [8086:2015]
00:14.0 USB controller [0c03]: Intel Corporation Sunrise Point-LP USB 3.0 xHCI Controller [8086:9d2f] (rev 21)
	Subsystem: Intel Corporation Sunrise Point-LP USB 3.0 xHCI Controller [8086:7270]
	Kernel driver in use: xhci_hcd
	Kernel modules: xhci_pci
00:14.2 Signal processing controller [1180]: Intel Corporation Sunrise Point-LP Thermal subsystem [8086:9d31] (rev 21)
	Subsystem: Intel Corporation Sunrise Point-LP Thermal subsystem [8086:7270]
	Kernel driver in use: intel_pch_thermal
	Kernel modules: intel_pch_thermal
00:14.3 Multimedia controller [0480]: Intel Corporation Device [8086:9d32] (rev 01)
	Subsystem: Intel Corporation Device [8086:7270]
	Kernel driver in use: ipu3-cio2
	Kernel modules: ipu3_cio2
00:15.0 Signal processing controller [1180]: Intel Corporation Sunrise Point-LP Serial IO I2C Controller #0 [8086:9d60] (rev 21)
	Subsystem: Intel Corporation Sunrise Point-LP Serial IO I2C Controller [8086:7270]
	Kernel driver in use: intel-lpss
	Kernel modules: intel_lpss_pci
00:15.1 Signal processing controller [1180]: Intel Corporation Sunrise Point-LP Serial IO I2C Controller #1 [8086:9d61] (rev 21)
	Subsystem: Intel Corporation Sunrise Point-LP Serial IO I2C Controller [8086:7270]
	Kernel driver in use: intel-lpss
	Kernel modules: intel_lpss_pci
00:15.2 Signal processing controller [1180]: Intel Corporation Sunrise Point-LP Serial IO I2C Controller #2 [8086:9d62] (rev 21)
	Subsystem: Intel Corporation Sunrise Point-LP Serial IO I2C Controller [8086:7270]
	Kernel driver in use: intel-lpss
	Kernel modules: intel_lpss_pci
00:15.3 Signal processing controller [1180]: Intel Corporation Sunrise Point-LP Serial IO I2C Controller #3 [8086:9d63] (rev 21)
	Subsystem: Intel Corporation Sunrise Point-LP Serial IO I2C Controller [8086:7270]
	Kernel driver in use: intel-lpss
	Kernel modules: intel_lpss_pci
00:16.0 Communication controller [0780]: Intel Corporation Sunrise Point-LP CSME HECI #1 [8086:9d3a] (rev 21)
	Subsystem: Intel Corporation Sunrise Point-LP CSME HECI [8086:7270]
	Kernel driver in use: mei_me
	Kernel modules: mei_me
00:16.4 Communication controller [0780]: Intel Corporation Device [8086:9d3e] (rev 21)
	Kernel driver in use: mei_me
	Kernel modules: mei_me
00:1c.0 PCI bridge [0604]: Intel Corporation Sunrise Point-LP PCI Express Root Port #5 [8086:9d14] (rev f1)
	Kernel driver in use: pcieport
00:1d.0 PCI bridge [0604]: Intel Corporation Sunrise Point-LP PCI Express Root Port #9 [8086:9d18] (rev f1)
	Kernel driver in use: pcieport
00:1d.3 PCI bridge [0604]: Intel Corporation Device [8086:9d1b] (rev f1)
	Kernel driver in use: pcieport
00:1f.0 ISA bridge [0601]: Intel Corporation Sunrise Point-LP LPC Controller [8086:9d48] (rev 21)
	Subsystem: Intel Corporation Sunrise Point-LP LPC Controller [8086:7270]
00:1f.2 Memory controller [0580]: Intel Corporation Sunrise Point-LP PMC [8086:9d21] (rev 21)
	Subsystem: Intel Corporation Sunrise Point-LP PMC [8086:7270]
00:1f.3 Audio device [0403]: Intel Corporation Sunrise Point-LP HD Audio [8086:9d70] (rev 21)
	Subsystem: Intel Corporation Sunrise Point-LP HD Audio [8086:7270]
	Kernel driver in use: snd_hda_intel
	Kernel modules: snd_hda_intel, snd_soc_skl
02:00.0 Non-Volatile memory controller [0108]: Toshiba America Info Systems NVMe Controller [1179:010f] (rev 01)
	Subsystem: Toshiba America Info Systems NVMe Controller [1179:0001]
	Kernel driver in use: nvme
03:00.0 Ethernet controller [0200]: Marvell Technology Group Ltd. 88W8897 [AVASTAR] 802.11ac Wireless [11ab:2b38]
	Subsystem: Device [0004:045e]
	Kernel driver in use: mwifiex_pcie
	Kernel modules: mwifiex_pcie, mwlwifi
```