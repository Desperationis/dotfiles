#!/usr/bin/env python3
from simple_term_menu import TerminalMenu
from os import listdir, system, geteuid
from os.path import isfile, join
import sys

if geteuid() == 0:
    print("You cannot be root.")
    sys.exit(1)

ansibleFolder = "./ansible/"

playbooks = [f for f in listdir(ansibleFolder) if isfile(join(ansibleFolder, f))]
playbooksStripped = [ f.split(".")[0] for f in playbooks ]

menu = TerminalMenu(
    playbooksStripped,
    multi_select=True,
    show_multi_select_hint=True,
)
indices = menu.show()

if indices == None:
    sys.exit(0)

for i in indices:
    file = join(ansibleFolder, playbooks[i])
    root = "become: true" in open(file, "r").read()

    if root:
        system(f"ansible-playbook {file} --ask-become-pass")
    else:
        system(f"ansible-playbook {file}")
