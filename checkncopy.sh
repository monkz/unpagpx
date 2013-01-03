#!/bin/bash
# Copyright (C) 2013 Malte Kuhn <git@monkz.de>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
# 
# On Debian systems, you can find the full text of the license in
# /usr/share/common-licenses/GPL-3
checkncopyTYPE=`file -bi "$1"`
if [[ $checkncopyTYPE == "application/xml"* ]]; then
  cp "$1" "$3/$2_`md5sum "$1" | cut -d' ' -f1`.gpx"
else
  echo -n "$2.gpx->"
  echo -n "$1: "
  echo $checkncopyTYPE
  #Treat file as xml
  cp "$1" "$3/$2_`md5sum "$1" | cut -d' ' -f1`.gpx"
fi
