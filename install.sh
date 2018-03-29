#!/bin/bash

check_make_ok() {
  if [ $? != 0 ]; then
    echo "failed."
    echo ""
    echo "================================================================================"
    if [ $2 == 1 ]; then
      echo "FATAL: Making $1 failed."
    else
      echo "Making $1 failed."
    fi
    echo "Please check install.log and fix any problems. If you're still stuck,"
    echo "then please open a new issue then post all the output and as many details as you can to"
    echo "  https://github.com/WiringPi/WiringPi-Node/issues"
    echo "================================================================================"
    echo ""
    if [ $2 == 1 ]; then
      exit 1
    fi
  fi
}

check_git_clone() {
  if [ $? != 0 ]; then
    echo "failed."
    echo ""
    echo "================================================================================"
    echo "FATAL: Cloning libWiringPi failed."
    echo "Please check install.log and fix any problems. If you're still stuck,"
    echo "then please open a new issue then post all the output and as many details as you can to"
    echo "  https://github.com/WiringPi/WiringPi-Node/issues"
    echo "================================================================================"
    echo ""
    exit 1
  fi
}

rm ./install.log 2>/dev/null 1>&2

echo -n "Cloning wiringPi ... "
rm -Rf ./wiringPi 2>/dev/null 1>&2
git clone https://github.com/jdcsa/wiringPi.git -b v2.46 > ./install.log 2>&1
check_git_clone
#git submodule init
#check_git_clone
#git submodule update
#check_git_clone
echo "done."

echo -n "Making wiringPi ... "
cd ./wiringPi/
chmod +x build
./build clean >> ../../install.log 2>&1
./build >> ../../install.log 2>&1
check_make_ok "wiringPi" 1
cd ../
echo "done."

echo -n "Making wiring-pi ... "
node-gyp rebuild 2>&1 | tee -a ./install.log
check_make_ok "wiring-pi" 1
echo "done."

echo "Enjoy !"
