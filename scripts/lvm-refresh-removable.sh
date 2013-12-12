#!/bin/bash
vgchange -a n "$1"
pvscan
vgscan
vgchange -a y "$1"
lvscan

mount "/dev/$1/$2" "/media/$1"
