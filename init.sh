#!/bin/bash

#初始化变量
WorkDir=$(cd `dirname $0`; pwd)
SoftDir=$WorkDir'/software'
TmpDir=$WorkDir'/tmp'
BashAuto=$WorkDir'/litsh.auto.bashrc'
BashOwn=$WorkDir'/litsh.bashrc'

#确认用户身份
if [ ! `whoami` == 'root' ] ; then
    echo 'Operation not permitted, run this script as root'
    exit
fi

mkdir -p $TmpDir

#确认 Package Manager
PaMa=$(type -p 'apt-get' || type -p 'yum')
if [ ! "$PaMa" ]; then
    echo "Your Package Manager ?"
    read PaMa
fi
echo "Use : "$PaMa

#初始化
cd $WorkDir
cat /dev/null > $BashAuto

#软件源直接安装
if [ "$PaMa" = "apt-get" ] ; then 
    $PaMa update
else
    $PaMa makecache
fi
$PaMa install -y python-pip pkg-config
$PaMa install -y htop iotop vim unzip tree screen

#pip 安装
Speedometer=$(type -t speedometer)
if [ ! "$Bat" ]; then
    pip install speedometer
fi
echo "alias sm='speedometer'" >> $BashAuto

#progress
Progress=$(type -t progress)
if [ ! "$Progress" ]; then
    $PaMa install -y libncurses5-dev 
    $PaMa install -y ncurses-devel
    unzip -o $SoftDir'/progress.zip' -d $TmpDir
    cd $TmpDir'/progress' && make && make install
fi
echo "alias progress='/usr/local/bin/progress'" >> $BashAuto

#Bat
Bat=$(type -t bat)
if [ ! "$Bat" ]; then
    unzip -o $SoftDir'/bat.zip' -d $TmpDir
    cp $TmpDir'/bat' /usr/local/bin/
fi
echo "alias bat='/usr/local/bin/bat'" >> $BashAuto

#导入自定义 bash 命令
BashrcFile=`ls /etc/* | grep bashrc | head -1`
if [ $(cat $BashrcFile | grep 'litsh' | wc -l) -eq 0 ] ; then
    echo "source $BashAuto" >> $BashrcFile
    echo "source $BashOwn" >> $BashrcFile
fi

