---
title: Golioth Logging sample
---

# Overview

This sample application demonstrates how to connect with Golioth and
configure logging backend to send system logs to Golioth.

# Requirements

-   Golioth credentials and server information
-   Network connectivity

# Building and Running

Configure the following Kconfig options based on your Golioth
credentials and server in your own overlay config file:

-   GOLIOTH_SERVER_IP_ADDR - Server IPv4 address.
-   GOLIOTH_SERVER_PORT - Server port number.
-   GOLIOTH_SERVER_DTLS_PSK_ID - PSK ID of registered device
-   GOLIOTH_SERVER_DTLS_PSK - PSK of registered device

## Platform specific configuration

### QEMU

This application has been built and tested with QEMU x86 (qemu_x86) and
QEMU ARM Cortex-M3 (qemu_cortex_m3).

On your Linux host computer, open a terminal window, locate the source
code of this sample application (i.e., `samples/logging`) and type:

``` {.console}
$ west build -b qemu_x86 samples/logging
$ west build -t run
```

See [Networking with
QEMU](https://docs.zephyrproject.org/latest/guides/networking/qemu_setup.html#networking-with-qemu)
on how to setup networking on host and configure NAT/masquerading to
access Internet.

### ESP32

Configure the following Kconfig options based on your WiFi AP
credentials:

-   ESP32_WIFI_SSID - WiFi SSID
-   ESP32_WIFI_PASSWORD - WiFi PSK

On your host computer open a terminal window, locate the source code of
this sample application (i.e., `samples/logging`) and type:

``` {.console}
$ west build -b esp32 samples/logging
$ west flash
```

This is the overlay template for WiFi credentials:

``` {.console}
CONFIG_ESP32_WIFI_SSID="my-wifi"
CONFIG_ESP32_WIFI_PASSWORD="my-psk"
```

See
[ESP32](https://docs.zephyrproject.org/latest/boards/xtensa/esp32/doc/index.html)
for details on how to use ESP32 board.

## Sample overlay file

This is the overlay template for Golioth credentials and server:

``` {.console}
CONFIG_GOLIOTH_SERVER_DTLS_PSK_ID="my-psk-id"
CONFIG_GOLIOTH_SERVER_DTLS_PSK="my-psk"
CONFIG_GOLIOTH_SERVER_IP_ADDR="192.168.1.10"
CONFIG_GOLIOTH_SERVER_PORT=5684
```

## Sample output

This is the output from the serial console:

``` {.console}
[00:00:00.100,000] <wrn> net_sock_tls: No entropy device on the system, TLS communication may be insecure!
[00:00:00.100,000] <inf> net_config: Initializing network
[00:00:00.100,000] <inf> net_config: IPv4 address: 192.0.2.1
[00:00:00.100,000] <dbg> golioth_logging.main: Start Logging sample
[00:00:00.100,000] <inf> golioth_logging: Initializing golioth client
[00:00:00.100,000] <inf> golioth_logging: Golioth client initialized
[00:00:00.100,000] <dbg> golioth_logging.main: Debug info! 0
[00:00:00.100,000] <dbg> golioth_logging.func_1: Log 1: 0
[00:00:00.100,000] <dbg> golioth_logging.func_2: Log 2: 0
[00:00:00.100,000] <wrn> golioth_logging: Warn: 0
[00:00:00.100,000] <err> golioth_logging: Err: 0
[00:00:00.100,000] <inf> golioth_logging: Counter hexdump
                                          00 00 00 00                                      |....
[00:00:00.100,000] <inf> golioth_logging: Starting connect
[00:00:00.110,000] <inf> golioth_logging: Client connected!
[00:00:05.110,000] <dbg> golioth_logging.main: Debug info! 1
[00:00:05.110,000] <dbg> golioth_logging.func_1: Log 1: 1
[00:00:05.110,000] <dbg> golioth_logging.func_2: Log 2: 1
[00:00:05.110,000] <wrn> golioth_logging: Warn: 1
[00:00:05.110,000] <err> golioth_logging: Err: 1
[00:00:05.110,000] <inf> golioth_logging: Counter hexdump
                                          01 00 00 00                                      |....
[00:00:10.120,000] <dbg> golioth_logging.main: Debug info! 2
[00:00:10.120,000] <dbg> golioth_logging.func_1: Log 1: 2
[00:00:10.120,000] <dbg> golioth_logging.func_2: Log 2: 2
[00:00:10.120,000] <wrn> golioth_logging: Warn: 2
[00:00:10.120,000] <err> golioth_logging: Err: 2
[00:00:10.120,000] <inf> golioth_logging: Counter hexdump
                                          02 00 00 00
```

## Access logs with goliothctl

This is how logs are visible

``` {.console}
$ goliothctl logs
[2021-04-08 14:20:32 +0000 UTC] level:WARN module:"golioth_logging" message:"Warn: 0" metadata:{fields:{key:"index" value:{number_value:9}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:INFO module:"golioth_logging" message:"Golioth client initialized" metadata:{fields:{key:"index" value:{number_value:5}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:INFO module:"golioth_logging" message:"Initializing golioth client" metadata:{fields:{key:"index" value:{number_value:4}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:INFO module:"net_config" message:"IPv4 address: 192.0.2.1" metadata:{fields:{key:"index" value:{number_value:2}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:INFO module:"golioth_logging" message:"Client connected!" metadata:{fields:{key:"index" value:{number_value:13}} fields:{key:"uptime" value:{number_value:110000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:INFO module:"golioth_logging" message:"Starting connect" metadata:{fields:{key:"index" value:{number_value:12}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:ERROR module:"golioth_logging" message:"Err: 0" metadata:{fields:{key:"index" value:{number_value:10}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:INFO module:"net_config" message:"Initializing network" metadata:{fields:{key:"index" value:{number_value:1}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:WARN module:"net_sock_tls" message:"No entropy device on the system, TLS communication may be insecure!" metadata:{fields:{key:"index" value:{number_value:0}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:INFO module:"golioth_logging" message:"Counter hexdump" metadata:{fields:{key:"hexdump" value:{string_value:"AAAAAA=="}} fields:{key:"index" value:{number_value:11}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:DEBUG module:"golioth_logging" message:"Debug info! 0" metadata:{fields:{key:"func" value:{string_value:"main"}} fields:{key:"index" value:{number_value:6}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:DEBUG module:"golioth_logging" message:"Start Logging sample" metadata:{fields:{key:"func" value:{string_value:"main"}} fields:{key:"index" value:{number_value:3}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:DEBUG module:"golioth_logging" message:"Log 2: 0" metadata:{fields:{key:"func" value:{string_value:"func_2"}} fields:{key:"index" value:{number_value:8}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
[2021-04-08 14:20:32 +0000 UTC] level:DEBUG module:"golioth_logging" message:"Log 1: 0" metadata:{fields:{key:"func" value:{string_value:"func_1"}} fields:{key:"index" value:{number_value:7}} fields:{key:"uptime" value:{number_value:100000}}} device_id:"xxxxxxxxxxxxxxxxxxxxxxxx"
```