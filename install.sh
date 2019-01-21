#!/bin/bash

platform=`uname -s`
if [ $platform = "Darwin" ]
then
    if [ `command -v brew | wc -l` -eq 0 ]
    then
            # Installs homebrew
            printf "\n\nInstalling homebrew...\n\n\n"
            # pipes the return to prevent the script from requesting user input
            printf "\n" | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
            
            if [ $? -ne 0 ]
            then
                    printf "\n\nHomebrew installation failed...\n\n\n"
                    exit 1
            fi
    fi

    # Installs wine
    printf "\n\nInstalling wine...\n\n\n"
    brew install wine winetricks
    if [ $? -ne 0 ]
    then
            printf "\n\nWine installation failed...\n\n\n"
            exit 1
    fi

elif [ $platform = "Linux" ]
then
    if [ `command -v wine | wc -l` -eq 0 ]
    then
        printf "\n\nInstalling wine...\n\n\n"
        sudo apt-get update
        sudo apt-get install wine winetricks
        if [ $? -ne 0 ]
        then
        		sudo apt-get install wine-stable winetricks
        		if [ $? -ne 0 ]
        		then
					printf "\n\nWine installation failed...\n\n\n"
                	exit 1
        		fi
        fi
    fi
fi

# mfc42 is needed for wine to run lasercut
winetricks mfc42 > /dev/null 2>&1
if [ $? -ne 0 ]
then
        printf "\n\nWinetricks configuration failed...\n\n\n"
        exit 1
fi
# updates the boot sector for faster app launch time
wineboot --update > /dev/null 2>&1

# starts the lasercut installer
printf "\n\nInstalling lasercut...\n\n\n"
wine LaserCut53/LaserCut/SetUp.exe > /dev/null 2>&1
if [ $? -eq 0 ]
then
        if [ $platform = "Darwin" ]
        then
            cp LaserCut53/launcher ./LaserCut
        elif [ $platform = "Linux" ]
        then
            sudo cp LaserCut53/launcher /usr/bin/lasercut
        fi
        printf "\n\nLaserCut installation COMPLETE !!\n\n\n"
        read -p "Press enter to continue..."
        exit 0
fi
