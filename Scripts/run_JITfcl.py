#!/usr/bin/env python3

import os
import sys
import argparse
import subprocess
from datetime import datetime
import shlex

# Function: Exit with error.
def exit_abnormal():
    usage()
    sys.exit(1)

# Function: Print a help message.
def usage():
    print("Usage: script_name.py [--copy_input_mdh --copy_input_ifdh]")
    print("e.g. script_name.py --copy_input_mdh")

# Function to run a shell command and return the output
def run_command(command):
    print(f"Running: {command}")
    result = subprocess.run(command, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error running command: {command}")
        print(result.stderr)
        exit_abnormal()
    print(result.stdout)
    return result.stdout

def main():
    parser = argparse.ArgumentParser(description="Process some inputs.")
    parser.add_argument("--copy_input_mdh", action="store_true", help="Copy input files using mdh")
    parser.add_argument("--copy_input_ifdh", action="store_true", help="Copy input files using ifhd")
    args = parser.parse_args()
    copy_input_mdh = args.copy_input_mdh
    copy_input_ifdh = args.copy_input_ifdh
    
    fname = os.getenv("fname")
    if not fname:
        print("Error: fname environment variable is not set.")
        exit_abnormal()

    print(f"{datetime.now()} starting fclless submission")
    print(f"args: {sys.argv}")
    print(f"fname={fname}")
    print(f"pwd={os.getcwd()}")
    print("ls of default dir")
    run_command("ls -al")

    CONDOR_DIR_INPUT = os.getenv("CONDOR_DIR_INPUT", ".")
    run_command(f"ls -ltr {CONDOR_DIR_INPUT}")

    try:
        IND = int(fname.split('.')[4].lstrip('0') or '0')
    except (IndexError, ValueError) as e:
        print("Error: Unable to extract index from filename.")
        exit_abnormal()

    TARF = run_command(f"ls {CONDOR_DIR_INPUT}/*.tar").strip()
    print(f"IND={IND} TARF={TARF}")

    FCL = os.path.basename(TARF)[:-6] + f".{IND}.fcl"

    if copy_input_mdh:
        run_command(f"mu2ejobfcl --jobdef {TARF} --index {IND} --default-proto file --default-loc dir:{os.getcwd()} > {FCL}")
        run_command(f"mu2ejobiodetail --jobdef {TARF} --index {IND} --inputs | mdh copy-file -e 3 -o -v -s tape -l local -")
    elif copy_input_ifdh:
        run_command(f"mu2ejobfcl --jobdef {TARF} --index {IND} --default-proto file --default-loc dir:{os.getcwd()} > {FCL}")
        infiles = run_command(f"mu2ejobiodetail --jobdef {TARF} --index {IND} --inputs| mdh print-url -s root -")
        infiles = infiles.split()
        for f in infiles:
            run_command(f"ifdh cp {f} .")
    else:
        run_command(f"mu2ejobfcl --jobdef {TARF} --index {IND} --default-proto root --default-loc tape > {FCL}")

    print(f"{datetime.now()} submit_fclless {FCL} content")
    with open(FCL, 'r') as f:
        print(f.read())
    run_command(f"loggedMu2e.sh -c {FCL}")

if __name__ == "__main__":
    main()
