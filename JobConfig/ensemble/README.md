# Introduction

This set of scripts is built to allow construction of "fake data-sets."

# Scripts

Since MDC2018 we have made huge progress in consolodating our scripts and as part of our MDC2020 effort we now have a set of multi-purpose scripts.

## python scripts

In the current generation of these scripts we require just two python scripts to mix our input DTS level primary files. The resulting "mixed" DTS sample should have a correctly normalized set of DTS events which can then be passed through the subsequent steps of the Production chain which result in a normalized reconstructed data sample of the given livetime input into the run_si.py script.

The most important thing to remember is to ensure that the livetime/POT are not going to result in more expected events from any process than is available in the input DTS files for that primary. This will result in a failure mode.

Also note that no trigger is applied to the DTS events, this will be applied in the digitization stage which follows ensembling.

### normalizations.py

This script is important. It calculates the normalization factors for each process. You can test it interactively by running it on command line. Livetime should be in hours.

### run_si.py

Runs "SI" which is SamplingInput. This is the script which is run last of all and makes the ensemble samples. It takes two arguments: 

* livetime (in seconds)
* BB (booster batch mode)
* rue (Rmue chosen)
* dem_emin (min energy for DIO)
* prc (list of process being input)
* tmin (time min cut)

The script will then call normalizations.py to calculate expected number of events per input type, and the total number of events in the ensemble. It will then iteratively create and run SamplingInput.fcl jobs, keeping track of which events in which files have been used, until the full ensemble is generated.

run_si.py is then ran on the command line in the following way: 

```
python run_si.py --stdpath=/pnfs/mu2e/scratch/users/sophie/filelists/ --BB=1BB --verbose=1 --rue=1e-13 --livetime=60 --run=1201 --dem_emin=75 --tmin=450 --samplingseed=1  --prc "CE" "DIO"
```

### make_template_fcl.py

Similar to the run_si script but it does not run the SI, it just makes a template fcl. The user can input any livetime by choosing the appropriate input files carefully.

### genEnsemblesGrid.sh

Runs make_si.py for given set of input files.

### getLivetime.sh

Calculates livetime for given set of cosmic files.

### calcualteInputs.sh

This script is to calculate how many of each process to generate. It uses the cosmics as the "standard". There is also a .txt. file output with the details of the chosen input parameters. This is not currently used for anything but could be passed into subsequent scripts to make things consistent.

### Workflow

1) Make the cosmic sample. S2 sample size is chosen to represent about 400s of live time.
2) Run calculateInputs.sh to work out how much of each other process to create and the job parameters.
3) Once the simulations are complete run MakeTemplateFcl.py to make the template.
4) Run genEnsemblesGrid.sh to make the ensemble.

### Making the input files

We choose the Cosmic jobs to be the "standard" since we do not expect to remake them too frequently.

The calculateInputs.sh file takes input in the form of a set of cosmic files, calculates livetime and the number of expected other events for the same livetime, assuming a given BB mode.

From the cosmics list, it assesses the livetime and then calculates how many other events would arrive in the same time for the chosen beam conditions.

The output is a text file which lists, number of final jobs needed (of course you can have more than this, but you will need to Cat the files). The file also lists total events for each input.

## To make the input processes

You will need to run each process separately, using the number of jobs and events from the previous script.

## Running on the Ensembling on the Grid

To make the template fcl file, first run genEnsemble.sh. The arguments are as follows:

```
bash ../Production/Scripts/gen_EnsembleGrid.sh --livetime 120 --run 1201 --dem_emin 75 --tmin 450 --BB 1BB --rmue 1e-13 --verbose 1 --tagg MSC1a
```

This will output a .tar file. This can be submitted to the grid as follows:

```
mu2ejobsub --jobdef cnf.sophie.ensemble.MDC2024a_sm4.0.tar --firstjob=0 --njobs=10  --predefined=sl7 --default-protocol ifdh --default-location tape
```

This is done within the script.

### POMs

The above command can be run interactively for personal submissions. For large-scale production...
