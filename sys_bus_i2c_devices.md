# sys_bus_i2c_devices

```
$ ls -lh /sys/bus/i2c/devices/
total 0
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-0 -> ../../../devices/pci0000:00/0000:00:02.0/i2c-0
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-1 -> ../../../devices/pci0000:00/0000:00:02.0/i2c-1
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-2 -> ../../../devices/pci0000:00/0000:00:02.0/i2c-2
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-3 -> ../../../devices/pci0000:00/0000:00:02.0/drm/card0/card0-eDP-1/i2c-3
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-4 -> ../../../devices/pci0000:00/0000:00:02.0/drm/card0/card0-DP-1/i2c-4
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-5 -> ../../../devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-5
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-6 -> ../../../devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-6
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-7 -> ../../../devices/pci0000:00/0000:00:15.2/i2c_designware.2/i2c-7
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-8 -> ../../../devices/pci0000:00/0000:00:15.3/i2c_designware.3/i2c-8
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-INT33BE:00 -> ../../../devices/pci0000:00/0000:00:15.2/i2c_designware.2/i2c-7/i2c-INT33BE:00
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-INT347A:00 -> ../../../devices/pci0000:00/0000:00:15.3/i2c_designware.3/i2c-8/i2c-INT347A:00
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-INT347E:00 -> ../../../devices/pci0000:00/0000:00:15.3/i2c_designware.3/i2c-8/i2c-INT347E:00
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-MAX34407:00 -> ../../../devices/pci0000:00/0000:00:15.1/i2c_designware.1/i2c-6/i2c-MAX34407:00
lrwxrwxrwx 1 root root 0 Jul 12 15:41 i2c-MSHW0030:00 -> ../../../devices/pci0000:00/0000:00:15.0/i2c_designware.0/i2c-5/i2c-MSHW0030:00
```

```
$ ls /sys/bus/i2c/devices/*
/sys/bus/i2c/devices/i2c-0:
delete_device  device  name  new_device  power  subsystem  uevent

/sys/bus/i2c/devices/i2c-1:
delete_device  device  name  new_device  power  subsystem  uevent

/sys/bus/i2c/devices/i2c-2:
delete_device  device  name  new_device  power  subsystem  uevent

/sys/bus/i2c/devices/i2c-3:
delete_device  device  name  new_device  power  subsystem  uevent

/sys/bus/i2c/devices/i2c-4:
delete_device  device  name  new_device  power  subsystem  uevent

/sys/bus/i2c/devices/i2c-5:
delete_device  device  firmware_node  i2c-MSHW0030:00  name  new_device  power  software_node  subsystem  uevent

/sys/bus/i2c/devices/i2c-6:
delete_device  device  firmware_node  i2c-MAX34407:00  name  new_device  power  software_node  subsystem  uevent

/sys/bus/i2c/devices/i2c-7:
delete_device  device  firmware_node  i2c-INT33BE:00  name  new_device  power  software_node  subsystem  uevent

/sys/bus/i2c/devices/i2c-8:
delete_device  device  firmware_node  i2c-INT347A:00  i2c-INT347E:00  name  new_device  power  software_node  subsystem  uevent

'/sys/bus/i2c/devices/i2c-INT33BE:00':
firmware_node  modalias  name  power  subsystem  uevent

'/sys/bus/i2c/devices/i2c-INT347A:00':
firmware_node  modalias  name  power  subsystem  uevent

'/sys/bus/i2c/devices/i2c-INT347E:00':
firmware_node  modalias  name  power  subsystem  uevent

'/sys/bus/i2c/devices/i2c-MAX34407:00':
firmware_node  modalias  name  power  subsystem  uevent

'/sys/bus/i2c/devices/i2c-MSHW0030:00':
0018:045E:0914.0001  driver  firmware_node  modalias  name  power  subsystem  uevent
```