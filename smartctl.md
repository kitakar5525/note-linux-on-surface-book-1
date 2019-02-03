Serial Number is hidden with XXXXXXXXXXXX.

```bash
sudo smartctl -a /dev/nvme0
smartctl 7.0 2018-12-30 r4883 [x86_64-linux-4.20.6-arch1-1-surface] (local build)
Copyright (C) 2002-18, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Number:                       THNSN5512GPU7 TOSHIBA
Serial Number:                      XXXXXXXXXXXX
Firmware Version:                   57MS4109
PCI Vendor/Subsystem ID:            0x1179
IEEE OUI Identifier:                0x0d0800
Controller ID:                      0
Number of Namespaces:               1
Namespace 1 Size/Capacity:          512,110,190,592 [512 GB]
Namespace 1 Formatted LBA Size:     512
Namespace 1 IEEE EUI-64:            00080d 02001bee29
Local Time is:                      Sun Feb  3 21:19:51 2019 JST
Firmware Updates (0x02):            1 Slot
Optional Admin Commands (0x0006):   Format Frmw_DL
Optional NVM Commands (0x000e):     Wr_Unc DS_Mngmt Wr_Zero
Warning  Comp. Temp. Threshold:     78 Celsius
Critical Comp. Temp. Threshold:     82 Celsius

Supported Power States
St Op     Max   Active     Idle   RL RT WL WT  Ent_Lat  Ex_Lat
 0 +     6.00W       -        -    0  0  0  0        0       0
 1 +     2.90W       -        -    1  1  1  1        0       0
 2 +     1.90W       -        -    2  2  2  2        0       0
 3 -   0.1600W       -        -    3  3  3  3     1000    1000
 4 -   0.0120W       -        -    4  4  4  4     5000   20000
 5 -   0.0060W       -        -    5  5  5  5   100000   60000

Supported LBA Sizes (NSID 0x1)
Id Fmt  Data  Metadt  Rel_Perf
 0 +     512       0         2
 1 -    4096       0         1

=== START OF SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SMART/Health Information (NVMe Log 0x02)
Critical Warning:                   0x00
Temperature:                        35 Celsius
Available Spare:                    100%
Available Spare Threshold:          10%
Percentage Used:                    3%
Data Units Read:                    15,676,421 [8.02 TB]
Data Units Written:                 21,486,593 [11.0 TB]
Host Read Commands:                 406,871,807
Host Write Commands:                272,105,829
Controller Busy Time:               1,268
Power Cycles:                       1,263
Power On Hours:                     3,577
Unsafe Shutdowns:                   359
Media and Data Integrity Errors:    0
Error Information Log Entries:      0
Warning  Comp. Temperature Time:    0
Critical Comp. Temperature Time:    0
Temperature Sensor 1:               35 Celsius

Error Information (NVMe Log 0x01, max 128 entries)
No Errors Logged
```
