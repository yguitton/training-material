#!/bin/bash

echo "checking file sizes"
exitcode=0
# check that test_data folder for workflows do not exceed 10MB

for TEST_DATA in topics/*/tutorials/*/workflows/test-data; do

if [[ $(du -sb $TEST_DATA | cut -f1) -gt 10485760 ]]; then
  echo "too big: $(du -sh $TEST_DATA)"
  exitcode=1
fi

done

exit $exitcode
