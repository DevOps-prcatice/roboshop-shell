#!/bin/bash
# This script is only for DRY

StatusCheck() {
  if [ $? -eq 0 ]; then
    echo -e "\e[32mSUCCESS\e[0m"
  else
    echo -e "\e[31mFAILURE\e[0m"
    exit 1
  fi

}
: '
UserStatus(){

  if [ $? -eq 0 ]; then
    echo "User already exists"
  else
    echo "Please add a user"
    exit 1
  fi
}
'

