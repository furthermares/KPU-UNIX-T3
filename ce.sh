#!/bin/bash

function ce(){
  #initalizing flags
  FLAG_b=0
  FLAG_f=0
  FLAG_h=0

  # print help [-h]
  function get_help(){
    cat << EOF
Usage:
  ce dir
  ce [-b|-f] dir
  ce -h
 
Options:
   (none)   Identical to \`cd *dir*\`
  -f       Identical to \`cd dir*\`
  -b       Identical to \`cd *dir\`
  -h       Show this page.
EOF
    return
  }

  # get option
  OPTIND=1
  while getopts "h:bf" opt; do
    case $opt in
      h) FLAG_h=1 ;;
      b) FLAG_b=1 ;;
      f) FLAG_f=1 ;;
      *) get_help ;;
    esac
  done

  # option -h selected
  if (( FLAG_h )); then
	get_help
  fi

  # print directory before ce
  echo "[SYS] pwd=[$PWD]"

  # option -f selected
  if (( FLAG_f )); then
    srchdir=$2*
  # option -b selected
  elif (( FLAG_b )); then
    srchdir=*$2
  # no option selected. default.
  else
    srchdir=*$1*
  fi 

  # lookup user input directory from current directory
  srchres=$(find $PWD -type d -name "$srchdir")
  # count the number of results
  srchres_cnt=$(wc -l <<< "$srchres")
  
  # case of (0,1,>1) results
  # 0 directory results. exit.
  if [[ -z $srchres ]]; then
    echo "No such directories found"
	return 0
  # 1 directory result. go to that directory.
  elif [[ $srchres_cnt = 1 ]]; then
    cd $srchdir
  else
  # more than 1 directories found. Choose one.
    echo "Multiple directories found. Choose number"

    declare -i i; i=1
	
	while IFS= read -r ; do
      echo "[$i] $REPLY"
      i=$((i+1))
    done <<< "$srchres"

    echo "[Select] << "
	read sel

    i=1
	while IFS= read -r; do
      if [[ $sel = $i ]]; then
	    cd $REPLY
      fi
	  i=$((i+1))
	done <<< "$srchres"
  fi

  
  # print directory after ce
  echo "[SYS] pwd=[$PWD]"
}
