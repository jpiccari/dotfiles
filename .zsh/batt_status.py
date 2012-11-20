#!/usr/bin/env python
# coding=UTF-8

import sys, math, subprocess

p = subprocess.Popen(["ioreg", "-rc", "AppleSmartBattery"], stdout=subprocess.PIPE)
output = p.communicate()[0]

o_max = [l for l in output.splitlines() if 'MaxCapacity' in l][0]
o_cur = [l for l in output.splitlines() if 'CurrentCapacity' in l][0]

b_max = float(o_max.rpartition('=')[-1].strip())
b_cur = float(o_cur.rpartition('=')[-1].strip())

charge = math.floor(b_cur / b_max * 100 * 10) / 10


color_green = '%{[32m%}'
color_yellow = '%{[1;33m%}'
color_red = '%{[31m%}'
color_reset = '%{[00m%}'
color_out = (
    color_green if charge > 65
    else color_yellow if charge > 35
    else color_red
)

if charge < 85:
	out = " " + color_out + str(charge) + "%%" + color_reset
	sys.stdout.write(out)
else:
	sys.stdout.write(color_reset)
