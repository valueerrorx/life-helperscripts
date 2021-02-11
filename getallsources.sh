#!/bin/bash

INSTALLED=$(dpkg -l |awk '/^[hi]i/{print $2}')
TOTAL=$(echo $INSTALLED | wc -w)

echo "---------------------------------------------"
echo "Total Number of installed packages: $TOTAL "
echo " UNCOMMENT ALL deb-src in sources.list     "
echo "---------------------------------------------"



mkdir SOURCES
cd SOURCES

sudo apt update

COUNT=0
for i in ${INSTALLED}
do
    let "COUNT +=1"
    echo "Downloading Source $COUNT of $TOTAL: $i"
    apt-get source ${i}
    rm -rf ./*/
done



cd ..
tar -zcvf life-sources.tar.gz SOURCES

