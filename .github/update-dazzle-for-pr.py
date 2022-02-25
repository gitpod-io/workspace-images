#!/usr/bin/env python3
import sys
import shutil
from ruamel.yaml import YAML


n = len(sys.argv)
if n != 2:
    raise Exception(
        "mandatory argument <suffix> missing, use update-dazzle-for-pr.py <suffix>")

suffix = sys.argv[1]

if len(suffix) == 0:
    raise Exception("mandatory argument <suffix> should not be empty")

# take backup
shutil.copy2("dazzle.yaml", "dazzle.yaml.orig")

yaml = YAML(typ="safe")

with open("dazzle.yaml.orig") as fp:
    data = yaml.load(fp)
    fp.close()

# add suffix '-<suffix>' to all the combo names and the references
for combo in data["combiner"]["combinations"]:
    combo["name"] += "-" + suffix
    if "ref" in combo:
        for i in range(len(combo["ref"])):
            combo["ref"][i] += "-" + suffix

with open("dazzle.yaml", "w") as final_fp:
    yaml.dump(data, final_fp)
    final_fp.close()
