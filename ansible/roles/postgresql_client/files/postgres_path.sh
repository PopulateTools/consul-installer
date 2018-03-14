#!/bin/sh

if [[ -e /usr/pgsql-9.6/bin ]]; then
  export PATH="/usr/pgsql-9.6/bin:${PATH}"
fi
