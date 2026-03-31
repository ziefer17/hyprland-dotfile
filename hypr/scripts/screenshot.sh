#!/bin/bash

FILE=~/Pictures/$(date +%Y_%m_%d_%H%M%S).png
grim "$FILE" && wl-copy < "$FILE"
