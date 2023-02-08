#!/bin/bash

inventory_file=inventory.ini

echo "[us-east-1]" > $inventory_file
terraform output us-east-1_ips | tr ',' '\n' | awk '{print $1}' >> $inventory_file

echo "[ca-central-1]" >> $inventory_file
terraform output ca-central-1_ips | tr ',' '\n' | awk '{print $1}' >> $inventory_file

echo "Inventory file created: $inventory_file"
