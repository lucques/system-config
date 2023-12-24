#!/usr/bin/env python3

import subprocess
from pathlib import Path
import datetime
import shutil
import re
import os
import sys


# Backup paths
teac = Path('/media/teac/backup')
teacRepos = teac / 'repos'
teacUnversioned = teac / 'unversioned'

# Shell
def exe(cmd):
    subprocess.call(cmd)

def exeRaw(cmd):
    os.system(cmd)

def exeOutput(cmd):
    result = subprocess.run(cmd, stdout=subprocess.PIPE)
    return result.stdout.decode('utf-8')


# Misc
def timestamp():
    return datetime.datetime.now().strftime("%y-%m-%d_%H-%M")

# Files
def maskFilename(str: str):
    return re.sub(r'[^\w\d\.-]','_',str)

def copy(source: Path, target: Path):
    shutil.copy(str(source), str(target))

def tar(sourceDir: Path, target: Path):
    exe(['tar', '-czvf', str(target), str(sourceDir)])

# Git
def gitAdd(f: Path):
    exe(["git", "add", str(f)])

def gitAddAll():
    exe(["git", "add", "--all"])

def gitCommit(m: str):
    exe(["git", "commit", "-m", m])

def gitPushAll():
    exeRaw("git remote | xargs -L1 git push --all")

def copyAdd(source: Path, target: Path):
    copy(source, target)
    gitAdd(target)


def print_python_info():
    print (sys.version)
    print (sys.version_info)
