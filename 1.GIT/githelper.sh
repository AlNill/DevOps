#!/bin/bash

git_folder="PAST YOUR FOLDER"

while getopts ':apm:c:b:h' opt; do
  case "$opt" in
    c)
      arg="$OPTARG"
      echo "Start clone git repository from: '$arg'."
      err=$(git clone $arg 2>&1)
      if [ $? -eq 0 ]; then
          echo "Success clone repository: '$arg'"
      else
          echo "ERROR: '$err'"
          exit 1
      fi 
      ;;
    b)
      cd $git_folder
      arg="$OPTARG"
      echo "Creating new branch '$arg'."
      if ! (err=$(git checkout -b $arg)) then
          echo "ERROR: '$err'"
          exit 1
      else
          if !(err_up=$(git push --set-upstream origin $arg)) then
              echo "ERROR: '$err_up'"
              exit 1
          else
              echo "Success create and push new branch: '$arg'. You are here."
          fi
      fi 
      ;;   
    a)
      cd $git_folder
      if [[ $(git ls-files --exclude-standard --others | wc -l) -gt 0 ]]; then
          echo "Add all files."
          if ! (err=$(git add --all)) then
              echo "ERROR: '$err'"
              exit 1
          else
              echo "Success adding all files."
          fi
      else
          if [[ $(git diff --exit-code | wc -l) -gt 0 ]]; then
              echo "Add all files."
              if ! (err=$(git add --all)) then
                  echo "ERROR: '$err'"
                  exit 1
              else
                  echo "Success adding all files."
              fi
          else
              echo "Nothing to add."
          fi 
      fi 
      ;;
    m)
      cd $git_folder
      msg="$OPTARG"
      if [[ `git diff --cached --exit-code` ]]; then
          echo "Creating commit with message '$msg'."
          if ! (err=$(git commit -m "$msg")) then
              echo "ERROR: '$err'"
              exit 1
          else
              echo "Success create commit with message: '$msg'."
          fi
      else
          echo "Nothing to commit."
      fi 
      ;;
    p)
      cd $git_folder
      err=$(git push 2>&1)
      if [[ $err == *'Everything up-to-date'* ]]; then
          echo "Nothing to push"
      else
          if [[ "$(git push --porcelain)" == *"Done"* ]]; then
              echo "Git push was successful."
              exit 0
          fi
          echo "ERROR: '$err'"
          exit 1
      fi    
      ;;     
    ?|h)
      printf "Usage: $(basename $0) [-a] [-p] [-m] arg [-c ] arg [-b] arg [-h].Where:\n -a - git add --all\n -p - git push\n -m message - git commit -m message\n -c url\ssh - git clone url\ssh\n -b branch_name - git checkout -b branch name. After then, new branch push to remote repository.\n -h - help infomation.\n DO NOT FORGET THAT COMMANDS RUN IN SERIES.\n DO NOT FORGET SET GIT REPOSITORY FOLDER IN SOURCE OF SCRIPT (VARIABLE git_folder)\n"
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
