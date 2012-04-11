#!/usr/bin/env python

import sys
import os
import datetime
import numpy as np
import matplotlib.pyplot as plt

FIT = False
DATETIME = True

if len(sys.argv) < 3:
    print 'Usage: %s [-t title] "x1 x2 x3 ..." "y1 y2 y3 ..." "[z1 z2 z3 ...]"' % sys.argv[0]
    sys.exit(1)

if sys.argv[1] == '-t':
    title = sys.argv[2]
    datapos = 3
else:
    title = None
    datapos = 1

def parseline(line):
    if os.path.exists(line):
        chunks = []
        for l in file(line):
            chunks.extend(l.strip().split())
    else:
        chunks = line.strip().split()
    return np.array(map(float, chunks))

x = parseline(sys.argv[datapos])
y = []
for i, line in enumerate(sys.argv[datapos+1:]):
    y.append( parseline(line) )

k = []
c = []

print 'y = k * x + c'
for i in xrange(len(y)):
    if len(x) != len(y[i]):
        print "len(x) ==", len(x), '!= len(y[i]) == ', len(y[i])
    A = np.vstack([x[0:len(y[i])], np.ones(len(y[i]))]).T

    ki, ci = np.linalg.lstsq(A, y[i])[0]
    k.append(ki)
    c.append(ci)
    print 'k_%d =' % i, k[i]
    print 'c_%d =' % i, c[i]

if DATETIME:
    x = map(datetime.datetime.fromtimestamp, x)
for i in xrange(len(y)):
    xslice = x[0:len(y[i])]
    if FIT:
        plt.plot(xslice, y[i], 'o', label='Original #%d' % i, markersize=5)
        plt.plot(xslice, k[i]*xslice + c[i], label='Fitted #%d' % i)
    else:
        plt.plot(xslice, y[i], label='Original #%d' % i)
plt.xlim(min(x), max(x))
if title is not None:
    plt.title(title)
if len(y) > 1 or FIT:
    plt.legend(loc=2)
plt.grid()
plt.show()
