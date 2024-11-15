#!/bin/bash

# First run: generate lists of testpoints
kibot --skip-pre all -c kibot_yaml/kibot_main.yaml testpoints

# Second run: generate all other outputs
kibot -c kibot_yaml/kibot_main.yaml -i testpoints
