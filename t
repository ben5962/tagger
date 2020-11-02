#!/bin/bash
[ -f "$1" ] && ln --symbolic "$1" $(basename $1)/.tags_dir/"$2"_"$1" 
