#!/bin/bash

WorkDir=$(cd `dirname $0`; pwd)
SoftDir=$WorkDir'/software'
TmpDir=$WorkDir'/tmp'
BashAuto=$WorkDir'/litsh.auto.bashrc'
BashOwn=$WorkDir'/litsh.bashrc'
mkdir -p $TmpDir

PaMa=$(type -p 'apt-get' || type -p 'yum')
if [ ! "$PaMa" ]; then
    echo "Your Package Manager ?"
    read PaMa
fi
echo "Use : "$PaMa

$PaMa update && $PaMa install -y htop iotop vim unzip

cd $WorkDir
cat /dev/null > $BashAuto

#progress
Progress=$(type -p progress)
if [ ! "$Progress" ]; then
    $PaMa install -y libncurses5-dev 
    $PaMa install -y ncurses-devel
    unzip -o $SoftDir'/progress.zip' -d $TmpDir
    cd $TmpDir'/progress' && make && make install
    echo "alias progress='progress -M'" >> $BashAuto
fi

#



#

if [ $(cat ~/.bashrc | grep 'litsh' | wc -l) -eq 0 ] ; then
    echo "source $BashAuto" >> ~/.bashrc
    echo "source $BashOwn"/litsh.bashrc' >> ~/.bashrc
fi
