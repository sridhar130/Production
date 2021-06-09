#!/bin/bash

for i in $(eval echo {1..$1});
  do echo "sim.$2.corsika.v1.$i.csk";
done
