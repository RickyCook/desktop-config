#!/bin/sh
wireshark -i lo -f 'tcp port 9200' -k
