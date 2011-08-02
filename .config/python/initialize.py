#!/usr/bin/python
# -*- encoding: utf-8 -*-

# Thanks to http://habrahabr.ru/blogs/python/46101

import sys, os, readline

histfile = os.path.join(os.environ["HOME"], ".python_history")

try:
  readline.read_history_file(histfile)
except IOError:
  pass
import atexit
atexit.register(readline.write_history_file, histfile)
del os, histfile

try:
  import readline
except ImportError:
  print "Module readline not available."
else:
  import rlcompleter
  readline.parse_and_bind("tab: complete")

# vim:set tabstop=4 softtabstop=4 shiftwidth=4 expandtab: 
