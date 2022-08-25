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

UserStatus(){
  id roboshop &>>/tmp/cart.log
  if [ $? -ne 0 ]; then
    echo Adding Application User
    useradd roboshop &>>/tmp/cart.log
    StatusCheck
  fi
}


