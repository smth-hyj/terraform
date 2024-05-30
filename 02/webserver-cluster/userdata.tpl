#!/bin/bash
echo "myWEB Server" > index.html
nohup busybox httpd -f -p 8080 &
