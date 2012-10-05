#!/bin/bash

# Common defines
txtrst='\e[0m'  # Color off
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue

echo -e "${txtylw}##############################################"
echo -e "${txtylw}#                                            #"
echo -e "${txtylw}#           TeamGlide Buildscrips            #"
echo -e "${txtylw}#     Follw us on github.com/TeamGlide       #"
echo -e "${txtylw}#                                            #"
echo -e "${txtylw}##############################################"
echo -e "\r\n ${txtrst}"

# Starting Timer
START=$(date +%s)
DEVICE="$1"
ADDITIONAL="$2"
THREADS=`cat /proc/cpuinfo | grep processor | wc -l`

# Device specific settings
case "$DEVICE" in
        glide)
                board=tegra
                lunch=cm_glide-userdebug
                brunch=cm_glide-userdebug
                ;;
	*)
		echo -e "${txtblu}Usage: $0 DEVICE ADDITIONAL"
		echo -e "Example: ./build.sh captivatemtd"
		echo -e "Example: ./build.sh captivatemtd kernel"
		echo -e "Supported Devices: glide${txtrst}"
		exit 2
		;;
esac

# Setting up Build Environment
echo -e "${txtgrn}Setting up Build Environment...${txtrst}"
. build/envsetup.sh
lunch ${lunch}

# Get Prebuilts
echo -e "${txtgrn}Getting Prebuilts...${txtrst}"
vendor/cm/get-prebuilts

# Start the Build
case "$ADDITIONAL" in
	kernel)
		echo -e "${txtgrn}Building Kernel...${txtrst}"
		cd kernel/samsung/${board}
		./build.sh "$DEVICE"
		cd ../../..
		echo -e "${txtgrn}Building Android...${txtrst}"
		brunch ${brunch}
		;;
	*)
		echo -e "${txtgrn}Building Android...${txtrst}"
		brunch ${brunch}
		;;
esac

END=$(date +%s)
ELAPSED=$((END - START))
E_MIN=$((ELAPSED / 60))
E_SEC=$((ELAPSED - E_MIN * 60))
printf "Elapsed: "
[ $E_MIN != 0 ] && printf "%d min(s) " $E_MIN
printf "%d sec(s)\n" $E_SEC
