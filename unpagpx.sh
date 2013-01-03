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
if ([ "$2" == "" ] || [ "$1" == "" ] || [ ! -d $2 ] || [ ! -d $1 ]); then
  echo "usage: $0 <sourcefolder> <destinationfolder>"
else
  unpagpxTMP=`mktemp -d --suffix=unpagpx`
  for savee in `ls $1*.gpx`; do
    #echo - $savee :
    saveeTYPE=`file -bzi $savee`
    #echo $saveeTYPE
     if [[ $saveeTYPE == "application/x-tar"*"compressed-encoding=application/x-gzip"* ]]; then
       tar -C "$unpagpxTMP" -xzf "$savee"
       :
     elif [[ $saveeTYPE == *"compressed-encoding=application/x-gzip"* ]]; then
       gzip -d < "$savee" > "$unpagpxTMP/decompressed-gz"
       :
     elif [[ $saveeTYPE == "application/x-tar"*"compressed-encoding=application/x-bzip2"* ]]; then
       tar -C "$unpagpxTMP" -xjf "$savee"
       :
     elif [[ $saveeTYPE == *"compressed-encoding=application/x-bzip2"* ]]; then
       bzip2 -d < "$savee" > "$unpagpxTMP/decompressed-bz2"
       :
     elif [[ $saveeTYPE == "application/x-tar"* ]]; then
       tar -C "$unpagpxTMP" -xf "$savee"
       :
     elif [[ $saveeTYPE == *"compressed-encoding=application/zip"* ]]; then
       unzip -q "$savee" -d "$unpagpxTMP"
       :
     elif ([[ $saveeTYPE == "application/xml"* ]] || [[ $saveeTYPE == "text/plain"* ]]); then
       cp "$savee" "$unpagpxTMP/"
       :
     else
#        UNKNOWN CONTAINER ignore
         echo -n "$savee :"
         echo $saveeTYPE 
     fi
     bsname=`basename $savee .gpx`
     counter=`mktemp --suffix=unpagpx`
     echo 0 > $counter
     find $unpagpxTMP -type f -exec ./checkncopy.sh {} $bsname $2 $counter \;
     rm $counter
     rm -r $unpagpxTMP/*
  done
  rm -rf $unpagpxTMP
fi

