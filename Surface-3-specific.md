# Surface 3 specific

- What is not working
  - Cameras
  - Touch input crashes after s2idle
    ```bash
    kern  :err   : [  +0.203408] Surface3-spi spi-MSHW0037:00: SPI transfer timed out
    ```

- What is working now which was not before
  - S0ix state
    - We can now go into S0ix after kernel 4.20 !
    ```bash
    /sys/devices/system/cpu/cpuidle/low_power_idle_cpu_residency_us
    30

    /sys/kernel/debug/pmc_atom/sleep_state
    S0IR Residency:32us
    S0I1 Residency:11456us
    S0I2 Residency:96us
    S0I3 Residency:7991840us
    S0   Residency:135887456us
    ```
  - `Display` section on GNOME settings
    - Now internal display appears on GNOME settings after latest kernel 4.19.x
