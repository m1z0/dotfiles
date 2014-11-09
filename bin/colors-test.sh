#!/bin/bash
 

function test_tput()
{
    # This program is free software. It comes without any warranty, to
    # the extent permitted by applicable law. You can redistribute it
    # and/or modify it under the terms of the Do What The Fuck You Want
    # To Public License, Version 2, as published by Sam Hocevar. See
    # http://sam.zoy.org/wtfpl/COPYING for more details.

    tput sgr 0
    for fgbg in {0..9} ; do #Foreground/Background
    	for color in {0..255} ; do #Colors
    		#Display the color
    		#echo -en "\e[${fgbg};5;${color}m ${color}\t\e[0m"
            tput setab ${fgbg}
            tput setaf ${color}
            echo -en "${color}\t "
    		#Display 10 colors per lines
    		if [ $((($color + 1) % 16)) == 0 ] ; then
                tput sgr 0
    			echo #New line
    		fi
    	done
        tput sgr 0
    	echo #New line
    done

    exit 0
}

function test_tput_fg()
{
    for bgcolor in {0..255} ; do #Foreground/Background
        for color in 166 226 228 220 ; do #Colors
            #Display the color
            tput setab ${bgcolor}
            tput setaf ${color}
            echo -en "${color}\t "
            #Display 10 colors per lines
            if [ $((($color + 1) % 16)) == 0 ] ; then
                tput sgr 0
                echo #New line
            fi
        done
        tput sgr 0
        echo #New line
    done

    exit 0
}

function test_escapes()
{ 
    # This program is free software. It comes without any warranty, to
    # the extent permitted by applicable law. You can redistribute it
    # and/or modify it under the terms of the Do What The Fuck You Want
    # To Public License, Version 2, as published by Sam Hocevar. See
    # http://sam.zoy.org/wtfpl/COPYING for more details.
     
    #Background
    for clbg in {40..47} {100..107} 49 ; do
        #Foreground
        for clfg in {30..37} {90..97} 39 ; do
            #Formatting
            for attr in 0 1 2 4 5 7 ; do
                #Print the result
                echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
            done
            echo #Newline
        done
    done
     
    exit 0
}

function test_escapes_2()
{
    for x in 0 1 4 5 7 8; do 
        for i in `seq 30 37`; do 
            for a in `seq 40 47`; do 
                echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "; 
            done; 
            echo; 
        done; 
    done; 
    echo "";
}

test_tput_fg