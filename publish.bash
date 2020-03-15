#!/bin/bash -e

if [[ $# -ne 0 ]]; then
  echo >&2 "usage: $(basename "$0")"
  exit 1
fi

docker build -t mfinelli/pgbackup .
docker push mfinelli/pgbackup

exit 0
