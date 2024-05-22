#!/usr/bin/env python
import os
from itertools import product
import argparse
#!/usr/bin/env python
import os
from itertools import product
import argparse
import json

# Parse command-line arguments
parser = argparse.ArgumentParser(description="Script to submit multiple POMS campaigns through project_py")
requiredNamed = parser.add_argument_group('required arguments')
requiredNamed.add_argument("--ini_file", type=str, help="INI file", required=True)
requiredNamed.add_argument("--cfg_file", type=str, help="CFG file", required=True)
requiredNamed.add_argument("--comb_json", type=str, help="JSON file that contains combinations to run over", required=True)

parser.add_argument("--create_campaign", action="store_true", help="Create campaigns")
parser.add_argument("--submit", action="store_true", help="Submit campaigns")
parser.add_argument("--test_run", action="store_true", help="Run in test run mode")
args = parser.parse_args()
ini_file = args.ini_file
cfg_file = args.cfg_file
comb_json = args.comb_json
test_run = args.test_run
create_campaign = args.create_campaign
submit = args.submit

release_v_dts = "ae"
release_v_dig = "ae"
release_v_rec = "ae"
release_v_o = "ae"

# Load combo_dict from file
with open(comb_json, "r") as file:
    combo_dict = json.load(file)

if test_run:
    for key, values in combo_dict.items():
        combo_dict[key] = [values[0]]  # Consider only one combination

list_values = list(product(*combo_dict.values()))
list_keys = list(combo_dict.keys())

for value in list_values:
    print(value)

    campaign_name = f"MDC2020{release_v_o}_digireco_{value[0]}_{value[1]}_{value[2]}_v0"
    out_ini_file = f"{campaign_name}.ini"
    os.system(f"cp {ini_file} {out_ini_file}")

    with open(out_ini_file, 'r') as file:
        file_data = file.read()

        file_data = file_data.replace("name = override_me", f"name = {campaign_name}")
        for i in range(len(list_keys)):
            file_data = file_data.replace(f'"{list_keys[i]}": "override_me"', f'"{list_keys[i]}": "{value[i]}"')

    with open(out_ini_file, 'w') as file:
        file.write(file_data)

    if create_campaign:
        cmd=f"Project.py --create_campaign --ini_file {out_ini_file} --cfg_file {cfg_file} --poms_role production"
        print(cmd)
        os.system(cmd)

    if submit:
        cmd=f"Project.py --submit --sam_experiment mu2e --experiment mu2e --campaign {campaign_name} --poms_role production"
        print(cmd)
        os.system(cmd)
