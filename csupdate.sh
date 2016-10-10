#!/bin/bash

TARGET_PATH=$1
CSFILE=cscope.files
PATTERN=( *.[chxsS] *.cpp *.h *.hpp *.mk Makefile *.inc *.dts *.dtsi )

echo "============Remove old cs files==========="
if [ -e $CSFILE ]; then
	for cstmp in "cscope.*"
	do
		echo "rm  $cstmp"
		rm -f $cstmp
	done
fi

echo "=============Gen new cs db=============="
for pattern in "${PATTERN[@]}"
do
	echo "search $pattern"
	find $TARGET_PATH -name $pattern >> $CSFILE
done	

echo "build db...."
cscope -bkq
echo "=============finish=============="
