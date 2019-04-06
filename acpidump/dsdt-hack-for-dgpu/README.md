# memo

## Command IDs

```
# part of HGON
^^I2C0.SAM.SCMD (0x05)
# part of HGOF
^^I2C0.SAM.SCMD (0x04)
# ADBG ("Send Apps not present cmd")
^^^I2C0.SAM.SCMD (0x07)
# ADBG ("Send Apps present cmd")
^^^I2C0.SAM.SCMD (0x06)
```

## Preparation

```bash
# enable ACPI debug log output
echo 0xFFFFFFFF > /sys/module/acpi/parameters/debug_layer
echo 0x00000002 > /sys/module/acpi/parameters/debug_level

sudo modprobe i2c-dev
#sudo modprobe -r i2c-hid

# acall(): Wrapper of acpi_call
# @$1: function or variable in DSDT
# [acpi - How do I use acpi_call? - Ask Ubuntu]
# (https://askubuntu.com/questions/102299/how-do-i-use-acpi-call)
# 
# Returns:
#       Same as acpi_call
# 
# examples:
#       acall "\_SB.PCI0.RP05.HGON"
#       acall "\_SB_.PCI0.LPCB.EC0_.VGBI._DSM {0x69 0x5C 0xD0 0x6F 0xE3 0xCD 0xF4 0x49 0x95 0xED \
#                                       0xAB 0x16 0x65 0x49 0x80 0x35} 1 1 0"
acall(){ echo "$1" | sudo tee /proc/acpi/call >/dev/null && sudo cat /proc/acpi/call;echo;}

# UUID to call dGPU related commands on `\_SB_.PCI0.LPCB.EC0_.VGBI._DSM ()`
# ToUUID ("6fd05c69-cde3-49f4-95ed-ab1665498035")
VGBI_UUID_DGPU="{0x69 0x5C 0xD0 0x6F 0xE3 0xCD 0xF4 0x49 0x95 0xED 0xAB 0x16 0x65 0x49 0x80 0x35}"
# Wrapper to call dGPU related commands on `\_SB_.PCI0.LPCB.EC0_.VGBI._DSM ()`
acall_vgbi_dgpu(){ acall "\_SB_.PCI0.LPCB.EC0_.VGBI._DSM $VGBI_UUID_DGPU 1 1 0";}

# scmd(): Wrapper of i2cset
# @$1: Command ID
# 
# examples:
#       scmd 0x04 # for turning off dGPU
#       scmd 0x05 # for turning on dGPU
#       scmd 0x06 # for "Send Apps present cmd"
#       scmd 0x07 # for "Send Apps not present cmd"
#       scmd 0x08 # for detach keyboard
scmd(){
    sudo i2cset -f -y 5 0x28 0x05 0x00 0x3f 0x03 0x24 0x06 0x00 0x13 0x00 0x24 "$1" \
        0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 i
}
```


## Enable dGPU

```bash
acall "\_SB.PCI0.RP05.HGON"
# Or,
# acall_vgbi_dgpu

# on another terminal
scmd 0x05
```