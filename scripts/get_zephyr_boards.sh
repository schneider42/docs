#!/bin/sh
if [ -d vendor/zephyr/.git ]
then
    cd vendor/zephyr
    git pull origin main
else
    mkdir -p vendor/zephyr
    cd vendor/zephyr
    git init
    git remote add origin https://github.com/zephyrproject-rtos/zephyr.git
    git config core.sparsecheckout true
    echo boards/ >> .git/info/sparse-checkout
    git pull origin main

    # --depth=1 might further reduce download size
    # without depth limitation, the download size is cuurently ~430 MB
fi
