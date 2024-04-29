#!/bin/bash
# Copies par file from dcache to tmp location. The file is then used to upload on grid nodes:
# submit.f_1 = dropbox:////tmp/cnf.%(submitter)s.%(stage_name)s.%(desc)s.0.tar
parfile=$1;
dir=$(samweb locate-file $parfile | sed 's/^dcache://');
cp $dir/$parfile /tmp/
