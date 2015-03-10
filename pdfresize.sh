#!/bin/bash

inputfile=""
outputFile=""

while [[ $# > 1 ]]
	do
	key="$1"

	case $key in
		-i|--input_file)
	    inputFile="$2"
	    shift
	    ;;
	    -o|--output_file)
	    outputFile="$2"
	    shift
	    ;;
	    *)
	            # unknown option
	    ;;
	esac
	shift
done

whiptail --title "  Choose compression level  " --menu " " 15 60 6 \
		"1)" "screen-view-only quality, 72 dpi images" \
		"2)" "low quality, 150 dpi images" \
		"3)" "high quality, 300 dpi images" \
		"4)" "high quality, color preserving, 300 dpi imgs" \
		"5)" "almost identical to /screen"  2>./.compressionLevel

opt=`head -1 .compressionLevel`;

if [ "$opt" = "" ]; then
	echo "No option choosed..."
	exit 0;
fi

dPDFSETTINGS=""

case "$opt" in
    '1)') dPDFSETTINGS="/screen" 
       	;;
    '2)') dPDFSETTINGS="/ebook"
       ;;
    '3)') dPDFSETTINGS="/printer" 
        ;;
    '4)') dPDFSETTINGS="/prepress" 
         ;;
    '5)') dPDFSETTINGS="/default"
         ;;
    *) 	echo 'Error'
		exit 1;
       ;;
esac

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS="$dPDFSETTINGS" -dNOPAUSE -dBATCH -sOutputFile="$outputFile" "$inputFile"

# If you cannot understand this, read Bash_Shell_Scripting#if_statements again.
if (whiptail --title "Example Dialog" --yesno "zip $outputFile?" 8 78) then

	zip_filename=$(whiptail --inputbox "Filename" 8 78 output --title "Zip filename" 3>&1 1>&2 2>&3)
                                                                        # A trick to swap stdout and stderr.
	# Again, you can pack this inside if, but it seems really long for some 80-col terminal users.
	exitstatus=$?
	if [ $exitstatus = 0 ]; then
	    zip -r "$zip_filename"".zip" "$outputFile"
	
	fi
	     
fi

echo "Succcess - Script completed!!!";
rm -f ./.compressionLevel


