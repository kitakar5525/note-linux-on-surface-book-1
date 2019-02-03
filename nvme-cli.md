Serial Number is hidden with XXXXXXXXXXXX.

```bash
sudo nvme id-ctrl -H /dev/nvme0 
NVME Identify Controller:
vid       : 0x1179
ssvid     : 0x1179
sn        :         XXXXXXXXXXXX
mn        : THNSN5512GPU7 TOSHIBA                   
fr        : 57MS4109
rab       : 1
ieee      : 0d0800
cmic      : 0
  [3:3] : 0	ANA not supported
  [2:2] : 0	PCI
  [1:1] : 0	Single Controller
  [0:0] : 0	Single Port

mdts      : 0
cntlid    : 0
ver       : 0
rtd3r     : 0
rtd3e     : 0
oaes      : 0
  [9:9] : 0	Firmware Activation Notices Not Supported
  [8:8] : 0	Namespace Attribute Changed Event Not Supported

ctratt    : 0
  [5:5] : 0	Predictable Latency Mode Not Supported
  [4:4] : 0	Endurance Groups Not Supported
  [3:3] : 0	Read Recovery Levels Not Supported
  [2:2] : 0	NVM Sets Not Supported
  [1:1] : 0	Non-Operational Power State Permissive Not Supported
  [0:0] : 0	128-bit Host Identifier Not Supported

rrls      : 0
oacs      : 0x6
  [8:8] : 0	Doorbell Buffer Config Not Supported
  [7:7] : 0	Virtualization Management Not Supported
  [6:6] : 0	NVMe-MI Send and Receive Not Supported
  [5:5] : 0	Directives Not Supported
  [4:4] : 0	Device Self-test Not Supported
  [3:3] : 0	NS Management and Attachment Not Supported
  [2:2] : 0x1	FW Commit and Download Supported
  [1:1] : 0x1	Format NVM Supported
  [0:0] : 0	Security Send and Receive Not Supported

acl       : 3
aerl      : 3
frmw      : 0x2
  [4:4] : 0	Firmware Activate Without Reset Not Supported
  [3:1] : 0x1	Number of Firmware Slots
  [0:0] : 0	Firmware Slot 1 Read/Write

lpa       : 0
  [3:3] : 0	Telemetry host/controller initiated log page Not Suporrted
  [2:2] : 0	Extended data for Get Log Page Not Supported
  [1:1] : 0	Command Effects Log Page Not Supported
  [0:0] : 0	SMART/Health Log Page per NS Not Supported

elpe      : 127
npss      : 5
avscc     : 0
  [0:0] : 0	Admin Vendor Specific Commands uses Vendor Specific Format

apsta     : 0x1
  [0:0] : 0x1	Autonomous Power State Transitions Supported

wctemp    : 351
cctemp    : 355
mtfa      : 0
hmpre     : 0
hmmin     : 0
tnvmcap   : 0
unvmcap   : 0
rpmbs     : 0
 [31:24]: 0	Access Size
 [23:16]: 0	Total Size
  [5:3] : 0	Authentication Method
  [2:0] : 0	Number of RPMB Units

edstt     : 0
dsto      : 0
fwug      : 0
kas       : 0
hctma     : 0
  [0:0] : 0	Host Controlled Thermal Management Not Supported

mntmt     : 0
mxtmt     : 0
sanicap   : 0
  [2:2] : 0	Overwrite Sanitize Operation Not Supported
  [1:1] : 0	Block Erase Sanitize Operation Not Supported
  [0:0] : 0	Crypto Erase Sanitize Operation Not Supported

hmminds   : 0
hmmaxd    : 0
nsetidmax : 0
anatt     : 0
anacap    : 0
  [7:7] : 0	Non-zero group ID Not Supported
  [6:6] : 0	Group ID does not change
  [4:4] : 0	ANA Change state Not Supported
  [3:3] : 0	ANA Persistent Loss state Not Supported
  [2:2] : 0	ANA Inaccessible state Not Supported
  [1:1] : 0	ANA Non-optimized state Not Supported
  [0:0] : 0	ANA Optimized state Not Supported

anagrpmax : 0
nanagrpid : 0
sqes      : 0x66
  [7:4] : 0x6	Max SQ Entry Size (64)
  [3:0] : 0x6	Min SQ Entry Size (64)

cqes      : 0x44
  [7:4] : 0x4	Max CQ Entry Size (16)
  [3:0] : 0x4	Min CQ Entry Size (16)

maxcmd    : 0
nn        : 1
oncs      : 0xe
  [6:6] : 0	Timestamp Not Supported
  [5:5] : 0	Reservations Not Supported
  [4:4] : 0	Save and Select Not Supported
  [3:3] : 0x1	Write Zeroes Supported
  [2:2] : 0x1	Data Set Management Supported
  [1:1] : 0x1	Write Uncorrectable Supported
  [0:0] : 0	Compare Not Supported

fuses     : 0
  [0:0] : 0	Fused Compare and Write Not Supported

fna       : 0
  [2:2] : 0	Crypto Erase Not Supported as part of Secure Erase
  [1:1] : 0	Crypto Erase Applies to Single Namespace(s)
  [0:0] : 0	Format Applies to Single Namespace(s)

vwc       : 0x1
  [0:0] : 0x1	Volatile Write Cache Present

awun      : 255
awupf     : 0
nvscc     : 0
  [0:0] : 0	NVM Vendor Specific Commands uses Vendor Specific Format

nwpc      : 0
  [2:2] : 0	Permanent Write Protect Not Supported
  [1:1] : 0	Write Protect Until Power Supply Not Supported
  [0:0] : 0	No Write Protect and Write Protect Namespace Not Supported

acwu      : 0
sgls      : 0
 [1:0]  : 0	Scatter-Gather Lists Not Supported

mnan      : 0
subnqn    : 
ioccsz    : 0
iorcsz    : 0
icdoff    : 0
ctrattr   : 0
  [0:0] : 0	Dynamic Controller Model

msdbd     : 0
ps    0 : mp:6.00W operational enlat:0 exlat:0 rrt:0 rrl:0
          rwt:0 rwl:0 idle_power:- active_power:-
ps    1 : mp:2.90W operational enlat:0 exlat:0 rrt:1 rrl:1
          rwt:1 rwl:1 idle_power:- active_power:-
ps    2 : mp:1.90W operational enlat:0 exlat:0 rrt:2 rrl:2
          rwt:2 rwl:2 idle_power:- active_power:-
ps    3 : mp:0.1600W non-operational enlat:1000 exlat:1000 rrt:3 rrl:3
          rwt:3 rwl:3 idle_power:- active_power:-
ps    4 : mp:0.0120W non-operational enlat:5000 exlat:20000 rrt:4 rrl:4
          rwt:4 rwl:4 idle_power:- active_power:-
ps    5 : mp:0.0060W non-operational enlat:100000 exlat:60000 rrt:5 rrl:5
          rwt:5 rwl:5 idle_power:- active_power:-
```

```bash
sudo nvme get-feature -f 0x0c -H /dev/nvme0
get-feature:0xc (Autonomous Power State Transition), Current value:0x000001
	Autonomous Power State Transition Enable (APSTE): Enabled
	Auto PST Entries	.................
	Entry[ 0]   
	.................
	Idle Time Prior to Transition (ITPT): 100 ms
	Idle Transition Power State   (ITPS): 3
	.................
	Entry[ 1]   
	.................
	Idle Time Prior to Transition (ITPT): 100 ms
	Idle Transition Power State   (ITPS): 3
	.................
	Entry[ 2]   
	.................
	Idle Time Prior to Transition (ITPT): 100 ms
	Idle Transition Power State   (ITPS): 3
	.................
	Entry[ 3]   
	.................
	Idle Time Prior to Transition (ITPT): 1250 ms
	Idle Transition Power State   (ITPS): 4
	.................
	Entry[ 4]   
	.................
	Idle Time Prior to Transition (ITPT): 8000 ms
	Idle Transition Power State   (ITPS): 5
	.................
	Entry[ 5]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[ 6]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[ 7]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[ 8]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[ 9]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[10]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[11]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[12]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[13]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[14]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[15]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[16]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[17]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[18]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[19]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[20]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[21]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[22]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[23]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[24]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[25]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[26]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[27]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[28]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[29]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[30]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
	Entry[31]   
	.................
	Idle Time Prior to Transition (ITPT): 0 ms
	Idle Transition Power State   (ITPS): 0
	.................
```
