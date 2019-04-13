#!/usr/bin/env bash

# Copyright (C) 2019 Shadow Of Mordor (energyspear17@xda)
# SPDX-License-Identifier: GPL-3.0-only

# Script used to build Shadow Kernel

# Kernel Config Variables

KERNEL_DIR="${PWD}"
KERNEL="shadow"
BUILD_USER="energyspear17"
BUILD_HOST="gcp"
DEVICE="kenzo"
VERSION="pie-treble"
ARCH="arm64"
CROSS_COMPILE="/home/${USER}/toolchain/gcc-linaro-6.4.1/bin/aarch64-linux-gnu-"
CCACHE_DIR="~/.ccache"
DTBTOOL=${KERNEL_DIR}/dtbTool

# Color configs

yellow='\033[0;33m'
white='\033[0m'
red='\033[0;31m'
gre='\e[0;32m'
blue='\033[0;34m'
cyan='\033[0;36m'

# Build configs

zimage="${KERNEL_DIR}/arch/arm64/boot/Image"
time=$(date +"%d-%m-%y-%T")
date=$(date +"%d-%m-%y")
v=$(grep "CONFIG_LOCALVERSION=" "${KERNEL_DIR}/arch/arm64/configs/${KERNEL}_defconfig" | cut -d- -f3- | cut -d\" -f1)
zip_name="${KERNEL}-${DEVICE}-${VERSION}-v${v}-${date}.zip"

function build() {

if [ "$1" = "qc" ]; then
    echo -e "$blue Applying qc patch ... \n $white"
    git apply qc.patch
    echo -e "$blue Building Kernel ... \n $white"

    export KBUILD_BUILD_HOST="${BUILD_HOST}"
    export KBUILD_BUILD_USER="${BUILD_USER}"
    export ARCH="${ARCH}"
    export CROSS_COMPILE="${CROSS_COMPILE}"
    export USE_CCACHE=1
    export CCACHE_DIR="${CCACHE_DIR}"
    ccache -M 50G
    make ${KERNEL}_defconfig
    make -j$(nproc --all) &>buildlog.txt & pid=$!

  spin[0]="$gre-"
  spin[1]="\\"
  spin[2]="|"
  spin[3]="/$nc"

  echo -ne "$yellow [Please wait...] ${spin[0]}$nc"
  while kill -0 $pid &>/dev/null
  do
    for i in "${spin[@]}"
    do
          echo -ne "\b$i"
          sleep 0.1
    done
  done

if ! [ -a ${zimage} ]; then
    echo -e "$red << Failed to compile zImage, check log and fix the errors first >>$white"
    git apply -R qc.patch
    exit 1
fi
echo -e "$yellow\n Build successful !\n $white"
echo -e "$blue\n Making DTB... \n $white"
${DTBTOOL} -2 -o ${KERNEL_DIR}/arch/arm64/boot/dt.img -s 2048 -p ${KERNEL_DIR}/scripts/dtc/ ${KERNEL_DIR}/arch/arm/boot/dts/ &>/dev/null
mv ${KERNEL_DIR}/arch/arm64/boot/dt.img ${KERNEL_DIR}/build/tools/dt2.img
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds >> \n $white" 
git apply -R qc.patch
else
 echo -e "$blue Building Kernel ... \n $white"
    git apply -R qc.patch
    export KBUILD_BUILD_HOST="${BUILD_HOST}"
    export KBUILD_BUILD_USER="${BUILD_USER}"
    export ARCH="${ARCH}"
    export CROSS_COMPILE="${CROSS_COMPILE}"
    export USE_CCACHE=1
    export CCACHE_DIR="${CCACHE_DIR}"
    ccache -M 50G
    make ${KERNEL}_defconfig
    make -j$(nproc --all) &>buildlog.txt & pid=$!

  spin[0]="$gre-"
  spin[1]="\\"
  spin[2]="|"
  spin[3]="/$nc"

  echo -ne "$yellow [Please wait...] ${spin[0]}$nc"
  while kill -0 $pid &>/dev/null
  do
    for i in "${spin[@]}"
    do
          echo -ne "\b$i"
          sleep 0.1
    done
  done

if ! [ -a ${zimage} ]; then
    echo -e "$red << Failed to compile zImage, check log and fix the errors first >>$white"
    exit 1
fi
echo -e "$yellow\n Build successful !\n $white"
echo -e "$blue\n Making DTB... \n $white"
${DTBTOOL} -2 -o ${KERNEL_DIR}/arch/arm64/boot/dt.img -s 2048 -p ${KERNEL_DIR}/scripts/dtc/ ${KERNEL_DIR}/arch/arm/boot/dts/ &>/dev/null
mv ${KERNEL_DIR}/arch/arm64/boot/dt.img ${KERNEL_DIR}/build/tools/dt1.img
End=$(date +"%s")
Diff=$(($End - $Start))
echo -e "$gre << Build completed in $(($Diff / 60)) minutes and $(($Diff % 60)) seconds >> \n $white" 
fi       
}

function clean() {

echo -e "$blue Cleaning... \n$white"
make clean && make mrproper
rm ${KERNEL_DIR}/arch/arm64/boot/Image

}

function menuconfig() {

echo -e "$blue Displaying Config Menu... \n$white"

export ARCH="${ARCH}"
make "${KERNEL}_defconfig"
make menuconfig

if [ -f "${KERNEL}_defconfig" ]; then
mv ${KERNEL}_defconfig arch/arm64/configs/${KERNEL}_defconfig
echo -e "$gre\n Configuration saved...\n $white"
else
echo -e "$yellow\n No defconfig saved from menuconfig...\n $white"
fi

}

function makezip() {
echo -e "$blue\n Generating flashable zip now... \n $white"
cd ${KERNEL_DIR}/build/
rm *.zip > /dev/null 2>&1

cp ${KERNEL_DIR}/arch/arm64/boot/Image ${KERNEL_DIR}/build/tools/Image1
cd ${KERNEL_DIR}/build/
zip -r ${zip_name} * > /dev/null

    case $1 in
        g)
	    gdupload
            ;;
        t)
	    tgram
            ;;
        tg)
	    gdupload
	    tgram
            ;;
        *)
           exit 1
    esac
cd ${KERNEL_DIR}
}

function gdupload(){

    if [ -f "/usr/local/bin/gdrive" ]; then
        gdrive upload ${zip_name}
    else
        echo -e "$yellow\n GDrive not found installing...\n $white"
        wget "https://drive.google.com/uc?id=10NAVLG-cNSPcPC-g3E-RfMgFksxJnyZu&export=download"
        mv "uc?id=10NAVLG-cNSPcPC-g3E-RfMgFksxJnyZu&export=download" gdrive
        chmod +x gdrive
        sudo install gdrive /usr/local/bin/gdrive
        rm gdrive
        if [ -f "/usr/local/bin/gdrive" ]; then
            echo -e "$blue\n GDrive Installed Successfully.. Configure gdrive and upload manually\n $white"
        else
            echo -e "$red << GDrive installation failed Try Installing Manually... >>$white"
        fi
    fi

}

function tgram(){

   if [ -f "${KERNEL_DIR}/impvar" ]; then

	source ${KERNEL_DIR}/impvar

	echo -e "$yellow\n Sending Files to Telegram Channel...\n $white"

	file_id=$(curl -F chat_id="${TCHANNEL}" -F document=@"${zip_name}" https://api.telegram.org/bot${BOT_API}/sendDocument | cut -d: -f4 | cut -d "," -f1)

	ch_id=$(curl -s -X POST https://api.telegram.org/bot${BOT_API}/sendMessage -d text="$(cat ${KERNEL_DIR}/ch.txt)" -d chat_id="${TCHANNEL}" | cut -d: -f4 | cut -d "," -f1)

	curl -s -X POST https://api.telegram.org/bot${BOT_API}/sendSticker -d chat_id="${TCHANNEL}" -d sticker="CAADBQADAgADMSh7G43ckmaE_h0aAg" 1> /dev/null

	echo -e "$blue\n Sending Files to Telegram Group...\n $white"

	curl -s -X POST https://api.telegram.org/bot${BOT_API}/forwardMessage -d chat_id="${TGROUP}" -d from_chat_id="${TCHANNEL}" -d message_id="${file_id}" 1> /dev/null

	curl -s -X POST https://api.telegram.org/bot${BOT_API}/forwardMessage -d chat_id="${TGROUP}" -d from_chat_id="${TCHANNEL}" -d message_id="${ch_id}" 1> /dev/null


    else
	echo -e "$red << Telegram import variables not found.. >>$white"
    fi
}

function main() {

echo -e ""

if [ "$1" = "" ]; then
    echo -e "$cyan \n\n███████╗██╗  ██╗ █████╗ ██████╗  ██████╗ ██╗    ██╗\n██╔════╝██║  ██║██╔══██╗██╔══██╗██╔═══██╗██║    ██║\n███████╗███████║███████║██║  ██║██║   ██║██║ █╗ ██║\n╚════██║██╔══██║██╔══██║██║  ██║██║   ██║██║███╗██║\n███████║██║  ██║██║  ██║██████╔╝╚██████╔╝╚███╔███╔╝\n╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝  ╚═════╝  ╚══╝╚══╝ \n\n  "
    echo -e "$blue\n 1.Build $KERNEL\n$gre\n 2.Make Menu Config\n$yellow\n 3.Clean Source\n$red\n 4.Exit\n$white"
    echo -n " Enter your choice:"
    read ch

    case $ch in
        1)
            read -r -p "Do you want to make flashable zip ? y/n :" ZIP
            if [ "$ZIP" = "y" ]; then
                read -r -p "Do you want to Upload to Gdrive/Telegram ? g/t/tg/n :" GD
            fi
            echo -e "$yellow Running make clean before compiling \n$white"
            clean
            Start=$(date +"%s")
            build
	    build 'qc'
	    makezip $GD
            ;;
        2)
            menuconfig
            ;;
        3)
            clean
            ;;
        *)
           exit 1
    esac
    
else
    case $1 in
        b)
            echo -e "$yellow Running make clean before compiling \n$white"
            clean
            Start=$(date +"%s")
            build
	    build 'qc'
            if [ "$2" = "y" ]; then
                makezip $3
            fi
            ;;
        mc)
            menuconfig
            ;;
        c)
            clean
            ;;
        u)
            if [ "$2" = "" ]; then
                echo -e "$red << Please Specify telegram or gdrive (t/g/tg)... >>$white"
                exit 2
            fi
	    makezip $2
	    ;;
        *)
           echo -e "$red << Unknown argument passed... >>$white"
           exit 1
    esac

fi
}

main $1 $2 $3 $4
