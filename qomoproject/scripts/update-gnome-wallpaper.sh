#!/bin/bash

GBP="/usr/share/gnome-background-properties"
XML_FILE="$GBP/qomo-wallpapers.xml"
PICS_DIR="/usr/share/backgrounds/qomo-wallpapers"

cat <<_EOF > $XML_FILE
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE wallpapers SYSTEM "gnome-wp-list.dtd">
<wallpapers>
_EOF

find $PICS_DIR -mindepth 2 | awk -F '/contents' '{print $1}' | uniq | while read dir_name
do
	cat <<_EOF > $dir_name/default.xml
<background>
  <starttime>
    <year>2016</year>
    <month>11</month>
    <day>15</day>
    <hour>00</hour>
    <minute>00</minute>
    <second>00</second>
  </starttime>
<static>
<duration>100000000.0</duration>
<file>
_EOF
	find $PICS_DIR -name "*.jpg" | grep $dir_name | while read line
	do
		w=`echo $line | awk -F '/' '{print $NF}' | awk -F '.jpg' '{print $1}' | awk -F 'x' '{print $1}'`
		h=`echo $line | awk -F '/' '{print $NF}' | awk -F '.jpg' '{print $1}' | awk -F 'x' '{print $2}'`
		cat <<_EOF >> $dir_name/default.xml
	<size width="$w" height="$h">$line</size>
_EOF
	done
	cat <<_EOF >> $dir_name/default.xml
</file>
</static>
</background>
_EOF
	name=`echo $dir_name | awk -F '/' '{print $NF}'`
	cat <<_EOF >> $XML_FILE
    <wallpaper deleted="false">
        <name>Qomo-wallpaper-$name</name>
        <name xml:lang="zh_CN">Qomo-wallpaper</name>
        <filename>$dir_name/default.xml</filename>
        <options>centered</options>
    </wallpaper>
_EOF
done

cat <<_EOF >> $XML_FILE
</wallpapers>
_EOF
