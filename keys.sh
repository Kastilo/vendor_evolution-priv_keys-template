#!/bin/bash

# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0

# Ensure working directory is local to this script
cd "$(dirname "$0")"

# Generate Android.bp
echo "// DO NOT EDIT THIS FILE MANUALLY" > Android.bp

for key in $(grep -o :\.\*override keys.mk | sort -u); do
    echo "" >> Android.bp
    echo "android_app_certificate {" >> Android.bp
    echo "    name: \"${key:1}\"," >> Android.bp
    echo "    certificate: \"${key:1}\"," >> Android.bp
    echo "}" >> Android.bp
done

# Generate keys
for key in ../../../build/make/target/product/security/*.pk8; do
    ./make_key.sh $(basename $key .pk8)
done

for key in $(grep -o :\.\*override keys.mk | sort -u); do
    ./make_key.sh ${key:1} 4096
done
