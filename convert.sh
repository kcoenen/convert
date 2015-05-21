#!/bin/bash
export PATH=/usr/local/bin:$PATH
array=()

# Read the file in parameter and fill the array named "array"
getArray() {
    i=0
    while read line # Read a line
    do
        array[i]=$line # Put it into the array
        i=$(($i + 1))
    done < $1
}

getArray "links.txt"

#for j in ${array[@]}; do echo $j; done

for j in ${array[@]}; do
	if [[ "$(sqlite3 youtube.db "select * from url where url='$j';" )" ]];
	then
		echo mp3 already downloaded
	else
		sudo youtube-dl --extract-audio  --audio-format mp3 -l https://www.youtube.com/watch?v=$j;
		sqlite3 youtube.db "INSERT INTO url (id, url) VALUES (NULL, '$j');"
	fi
done

