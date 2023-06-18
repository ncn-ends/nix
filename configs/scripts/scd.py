#!/usr/bin/env python3

# https://stackoverflow.com/questions/21406887/subprocess-changing-directory

import os
import sys

import subprocess

list_files = subprocess.call(["cd", "/"], shell=True)
os.system("/bin/bash")

# targetDir = sys.argv[1] if 1 < len(sys.argv) else None
# startDir = sys.argv[2] if 2 < len(sys.argv) else os.path.expanduser('~')

# if (targetDir is None):
#     sys.exit("Must provide target directory as first argument.")

# print(sys.argv)
# print(targetDir)
# print(startDir)

# # subdir = os.walk(startDir)
# # print(subdir.next())
# for root, dirs, files in os.walk(startDir, topdown=False):
#    for name in dirs:
#     if (name == targetDir):
#         fullPath = os.path.join(root, name)
#         os.system("cd %s" % fullPath)
#         sys.exit("Entering: %s" % fullPath)

# sys.exit("No directories found by that name.")