---
title: Golioth LightDB sample
---

Overview
========

This LightDB application demonstrates how to connect with Golioth and
access LightDB.

Requirements
============

-   Golioth credentials
-   Network connectivity

Building and Running
====================

Configure the following Kconfig options based on your Golioth
credentials:

-   GOLIOTH\_SYSTEM\_CLIENT\_PSK\_ID - PSK ID of registered device
-   GOLIOTH\_SYSTEM\_CLIENT\_PSK - PSK of registered device

by adding these lines to configuration file (e.g. `prj.conf`):

``` {.cfg}
CONFIG_GOLIOTH_SYSTEM_CLIENT_PSK_ID="my-psk-id"
CONFIG_GOLIOTH_SYSTEM_CLIENT_PSK="my-psk"
```

Platform specific configuration
-------------------------------

### QEMU

This application has been built and tested with QEMU x86 (qemu\_x86) and
QEMU ARM Cortex-M3 (qemu\_cortex\_m3).

On your Linux host computer, open a terminal window, locate the source
code of this sample application (i.e., `samples/lightdb`) and type:

``` {.console}
$ west build -b qemu_x86 samples/lightdb
$ west build -t run
```

See [Networking with
QEMU](https://docs.zephyrproject.org/latest/guides/networking/qemu_setup.html#networking-with-qemu)
on how to setup networking on host and configure NAT/masquerading to
access Internet.

### ESP32

#### Configure ESP32 LightDB sample

Configure the following Kconfig options based on your WiFi AP
credentials:

-   GOLIOTH\_SAMPLE\_WIFI\_SSID - WiFi SSID
-   GOLIOTH\_SAMPLE\_WIFI\_PSK - WiFi PSK

by adding these lines to configuration file (e.g. `prj.conf` or
`board/esp32.conf`):

``` {.cfg}
CONFIG_GOLIOTH_SAMPLE_WIFI_SSID="my-wifi"
CONFIG_GOLIOTH_SAMPLE_WIFI_PSK="my-psk"
```

#### Add ESP32 Overlay

Create the following file as `esp32.overlay` in the `boards` subdirectory inside the LightDB demo directory to have access to the LED_0-3 pins:

```
/ {
  leds {
    compatible = "gpio-leds";
    //compatible = "esp32-gpio";
    led0: led_0 {
      gpios = <&gpio0 5 GPIO_ACTIVE_LOW>;
      label = "Onboard LED 0";
    };
    led1: led_1 {
      gpios = <&gpio0 18 GPIO_ACTIVE_LOW>;
      label = "Green LED 1";
    };
    led2: led_2 {
      gpios = <&gpio0 23 GPIO_ACTIVE_LOW>;
      label = "Green LED 2";
    };
    led3: led_3 {
      gpios = <&gpio0 19 GPIO_ACTIVE_LOW>;
      label = "Green LED 3";
    };
  };
  aliases {
    led0 = &led0;
    led1 = &led1;
    led2 = &led2;
    led3 = &led3;
  };
};

```

#### Build ESP32 LightDB sample

On your host computer open a terminal window, locate the source code of
this sample application (i.e., `samples/lightdb`) and type:

``` {.console}
$ west build -b esp32 samples/lightdb
$ west flash
```

See
[ESP32](https://docs.zephyrproject.org/latest/boards/xtensa/esp32/doc/index.html)
for details on how to use ESP32 board.

### nRF52840 DK + ESP32-WROOM-32

This subsection documents using nRF52840 DK running Zephyr with
offloaded ESP-AT WiFi driver and ESP32-WROOM-32 module based board (such
as ESP32 DevkitC rev. 4) running WiFi stack. See [AT Binary
Lists](https://docs.espressif.com/projects/esp-at/en/latest/AT_Binary_Lists/index.html)
for links to ESP-AT binaries and details on how to flash ESP-AT image on
ESP chip. Flash ESP chip with following command:

``` {.console}
esptool.py write_flash --verify 0x0 PATH_TO_ESP_AT/factory/factory_WROOM-32.bin
```

Connect nRF52840 DK and ESP32-DevKitC V4 (or other ESP32-WROOM-32 based
board) using wires:

  ----------- ----------------
  nRF52840 DK ESP32-WROOM-32

  P1.01 (RX)  IO17 (TX)

  P1.02 (TX)  IO16 (RX)

  P1.03 (CTS) IO14 (RTS)

  P1.04 (RTS) IO15 (CTS)

  P1.05       EN

  GND         GND
  ----------- ----------------

Configure the following Kconfig options based on your WiFi AP
credentials:

-   GOLIOTH\_SAMPLE\_WIFI\_SSID - WiFi SSID
-   GOLIOTH\_SAMPLE\_WIFI\_PSK - WiFi PSK

by adding these lines to configuration file (e.g. `prj.conf` or
`board/nrf52840dk_nrf52840.conf`):

``` {.cfg}
CONFIG_GOLIOTH_SAMPLE_WIFI_SSID="my-wifi"
CONFIG_GOLIOTH_SAMPLE_WIFI_PSK="my-psk"
```

On your host computer open a terminal window, locate the source code of
this sample application (i.e., `samples/lightdb`) and type:

``` {.console}
$ west build -b nrf52840dk_nrf52840 samples/lightdb
$ west flash
```

Sample output
-------------

This is the output from the serial console:

``` {.console}
[00:00:00.010,000] <wrn> net_sock_tls: No entropy device on the system, TLS communication may be insecure!
[00:00:00.010,000] <inf> net_config: Initializing network
[00:00:00.010,000] <inf> net_config: IPv4 address: 192.0.2.1
[00:00:00.010,000] <dbg> golioth_lightdb.main: Start LightDB sample
[00:00:00.020,000] <inf> golioth_lightdb: Initializing golioth client
[00:00:00.020,000] <inf> golioth_lightdb: Golioth client initialized
[00:00:00.020,000] <inf> golioth_lightdb: Starting connect
[00:00:00.040,000] <inf> golioth_lightdb: Client connected!
[00:00:00.040,000] <dbg> golioth_lightdb: Payload
                                          a1 63 6d 73 67 62 4f 4b                          |.cmsgbOK
[00:00:00.040,000] <wrn> golioth_lightdb: Map key is not boolean
[00:00:00.040,000] <dbg> golioth_lightdb: Payload
                                          a4 61 31 f4 61 32 f5 61  33 f5 61 30 f5          |.a1.a2.a 3.a0.
[00:00:00.040,000] <inf> golioth_lightdb: LED 1 -> 0
[00:00:00.040,000] <inf> golioth_lightdb: LED 2 -> 1
[00:00:00.040,000] <inf> golioth_lightdb: LED 3 -> 1
[00:00:00.040,000] <inf> golioth_lightdb: LED 0 -> 1
```

Monitor counter value
---------------------

Device increments counter every 5s and updates `/counter` resource in
LightDB with its value. Current value can be fetched using following
command:

``` {.console}
goliothctl lightdb get <device-name> /counter
```

Control LEDs
------------

Multiple LEDs can be changed simultaneously using following command:

``` {.console}
goliothctl lightdb set <device-name> /led -b '{"0":true,"1":false,"2":true,"3":true}'
```

This request should result in following serial console output:

``` {.console}
[00:00:04.050,000] <dbg> golioth_lightdb: Payload
                                          a4 61 33 f5 61 30 f5 61  31 f4 61 32 f5          |.a3.a0.a 1.a2.
[00:00:04.050,000] <inf> golioth_lightdb: LED 3 -> 1
[00:00:04.050,000] <inf> golioth_lightdb: LED 0 -> 1
[00:00:04.050,000] <inf> golioth_lightdb: LED 1 -> 0
[00:00:04.050,000] <inf> golioth_lightdb: LED 2 -> 1
```

Additionally board LEDs will be changed, if they are configured in
device-tree as:

-   `/aliases/led0`
-   `/aliases/led1`
-   `/aliases/led2`
-   `/aliases/led3`