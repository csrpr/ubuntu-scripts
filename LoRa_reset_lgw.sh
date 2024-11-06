#!/bin/sh

# This script is intended to be used on SX1302 CoreCell platform, it performs
# the following actions:
#       - export/unpexort GPIO23 and GPIO18 used to reset the SX1302 chip and to enable the LDOs
#       - export/unexport GPIO22 used to reset the optional SX1261 radio used for LBT/Spectral Scan
#
# Usage examples:
#       ./reset_lgw.sh stop
#       ./reset_lgw.sh start

# GPIO mapping has to be adapted with HW
#

SX1302_RESET_PIN=17     # SX1302 reset
SX1302_POWER_EN_PIN=18  # SX1302 power enable
SX1261_RESET_PIN=5     # SX1261 reset (LBT / Spectral Scan)
AD5338R_RESET_PIN=13    # AD5338R reset (full-duplex CN490 reference design)

WAIT_GPIO() {
    sleep 0.1
}

init() {
    # setup GPIOs
    export_gpio $SX1302_RESET_PIN
    export_gpio $SX1261_RESET_PIN
    export_gpio $SX1302_POWER_EN_PIN
    export_gpio $AD5338R_RESET_PIN

    # set GPIOs as output
    set_gpio_direction $SX1302_RESET_PIN
    set_gpio_direction $SX1261_RESET_PIN
    set_gpio_direction $SX1302_POWER_EN_PIN
    set_gpio_direction $AD5338R_RESET_PIN
}

export_gpio() {
    if [ ! -d "/sys/class/gpio/gpio$1" ]; then
        echo "$1" > /sys/class/gpio/export
        WAIT_GPIO
    fi
}

set_gpio_direction() {
    echo "out" > /sys/class/gpio/gpio$1/direction
    WAIT_GPIO
}

reset() {
    echo "CoreCell reset through GPIO$SX1302_RESET_PIN..."
    echo "SX1261 reset through GPIO$SX1302_RESET_PIN..."
    echo "CoreCell power enable through GPIO$SX1302_POWER_EN_PIN..."
    echo "CoreCell ADC reset through GPIO$AD5338R_RESET_PIN..."

    # write output for SX1302 CoreCell power_enable and reset
    echo "1" > /sys/class/gpio/gpio$SX1302_POWER_EN_PIN/value; WAIT_GPIO

    echo "1" > /sys/class/gpio/gpio$SX1302_RESET_PIN/value; WAIT_GPIO
    echo "0" > /sys/class/gpio/gpio$SX1302_RESET_PIN/value; WAIT_GPIO

    echo "0" > /sys/class/gpio/gpio$SX1261_RESET_PIN/value; WAIT_GPIO
    echo "1" > /sys/class/gpio/gpio$SX1261_RESET_PIN/value; WAIT_GPIO

    echo "0" > /sys/class/gpio/gpio$AD5338R_RESET_PIN/value; WAIT_GPIO
    echo "1" > /sys/class/gpio/gpio$AD5338R_RESET_PIN/value; WAIT_GPIO
}

term() {
    # cleanup all GPIOs
    unexport_gpio $SX1302_RESET_PIN
    unexport_gpio $SX1261_RESET_PIN
    unexport_gpio $SX1302_POWER_EN_PIN
    unexport_gpio $AD5338R_RESET_PIN
}

unexport_gpio() {
    if [ -d "/sys/class/gpio/gpio$1" ]; then
        echo "$1" > /sys/class/gpio/unexport
        WAIT_GPIO
    fi
}

# Ensure cleanup is always called on script exit (even if interrupted)
trap term EXIT

case "$1" in
    start)
        term # just in case
        init
        reset
        ;;
    stop)
        reset
        term
        ;;
    *)
        echo "Usage: $0 {start|stop}"
        exit 1
        ;;
esac

exit 0
