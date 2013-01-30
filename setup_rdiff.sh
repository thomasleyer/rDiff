#/bin/bash

#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Written (W) 2009-2013 Gunnar Raetsch, Regina Bohnert, Philipp Drewe
# Copyright (C) 2009-2013 Max Planck Society, Sloan-Kettering Institute
#

set -e 

. ./bin/rdiff_config.sh

echo =====================================
echo  rDiff setup script \(version $RDIFF_VERSION\) 
echo =====================================
echo

echo rDiff base directory \(currently set to \"$RDIFF_PATH\", suggest to set to \"`pwd`\", used if left empty\)
read RDIFF_PATH       
if [ "$RDIFF_PATH" == "" ];
then
	RDIFF_PATH=`pwd`
fi
echo '=>' Setting rDiff base directory to \"$RDIFF_PATH\"
echo

echo SAMTools directory \(currently set to \"$RDIFF_SAMTOOLS_BIN_DIR\", system version used if left empty\)
read RDIFF_SAMTOOLS_BIN_DIR
if [ "$RDIFF_SAMTOOLS_BIN_DIR" == "" ];
then
	if [ "$(which samtools)" != "" ] ;
	then
		RDIFF_SAMTOOLS_BIN_DIR=$(which samtools)
	    if [ -f $(dirname $(which samtools))/../include/bam/sam.h ]
	    then
			RDIFF_SAMTOOLS_INCLUDE_DIR=$(dirname $(which samtools))/../include/bam/
			echo "Include found: $RDIFF_SAMTOOLS_INCLUDE_DIR"
	    else
			echo "ERROR: Include sam.h include not found"
			exit -1 ;
	    fi
	    if [ -f $(dirname $(which samtools))/../lib/libbam.a ]
	    then
			RDIFF_SAMTOOLS_LIB_DIR=$(dirname $(which samtools))/../lib/
			echo "Library found: $RDIFF_SAMTOOLS_LIB_DIR"
	    else
			echo "ERROR: Library libbam.a not found"
			exit -1 ;
	    fi
	else
	    echo libraries not found
	    exit -1 ;
	fi
else
	if [ ! -f $RDIFF_SAMTOOLS_BIN_DIR ];
	then
		echo "ERROR: Binary $RDIFF_SAMTOOLS_BIN_DIR not found"
		exit -1 ;
	fi

	echo SAMTools Include directory \(currently set to \"$RDIFF_SAMTOOLS_INCLUDE_DIR\"\)
	read RDIFF_SAMTOOLS_INCLUDE_DIR
	if [ ! -f $RDIFF_SAMTOOLS_INCLUDE_DIR/sam.h ]
	then
		echo "ERROR: Include $RDIFF_SAMTOOLS_INCLUDE_DIR/sam.h include not found"
		exit -1 ;
	fi
	
	echo SAMTools library directory \(currently set to \"$RDIFF_SAMTOOLS_LIB_DIR\"\)
	read RDIFF_SAMTOOLS_LIB_DIR
	if [ ! -f $RDIFF_SAMTOOLS_LIB_DIR/libbam.a ]
	then
		echo "ERROR: Library $RDIFF_SAMTOOLS_LIB_DIR/libbam.a include not found"
		exit -1 ;
	fi
fi
echo '=>' Setting samtools directory to \"$RDIFF_SAMTOOLS_BIN_DIR\"
echo

echo Path to the python binary \(currently set to \"$RDIFF_PYTHON_PATH\", system version used, if left empty\)
read RDIFF_PYTHON_PATH
if [ "$RDIFF_PYTHON_PATH" == "" ];
then
    RDIFF_PYTHON_PATH=`which python`
	if [ "$RDIFF_PYTHON_PATH" == "" ];
	then
		echo python not found
		exit -1 
	fi
fi
echo '=>' Setting Python path to \"$RDIFF_PYTHON_PATH\"
echo

RDIFF_INTERPRETER="octave"

if [ "$RDIFF_INTERPRETER" == 'octave' ];
then
	echo Please enter the full path to octave \(currently set to \"$RDIFF_OCTAVE_BIN_PATH\", system version used, if left empty\)
	read RDIFF_OCTAVE_BIN_PATH
	if [ "$RDIFF_OCTAVE_BIN_PATH" == "" ];
	then
	    RDIFF_OCTAVE_BIN_PATH=`which octave` 
		if [ "$RDIFF_OCTAVE_BIN_PATH" == "" ];
		then
			echo octave not found
			exit -1
		fi
	fi
	echo '=>' Setting octave\'s path to \"$RDIFF_OCTAVE_BIN_PATH\"
	echo

	echo Please enter the full path to mkoctfile \(currently set to \"$RDIFF_OCTAVE_MKOCT\", system version used, if left empty\)
	read RDIFF_OCTAVE_MKOCT
	if [ "$RDIFF_OCTAVE_MKOCT" == "" ];
	then
	    RDIFF_OCTAVE_MKOCT=`which mkoctfile` 
		if [ "$RDIFF_OCTAVE_MKOCT" == "" ];
		then
			RDIFF_OCTAVE_MKOCT=$(dirname $RDIFF_OCTAVE_BIN_PATH)/mkoctfile
			if [ ! -f RDIFF_OCTAVE_MKOCT ];
			then
				echo mkoctfile not found
				exit -1
			fi
		fi
	fi
	echo '=>' Setting octave\'s path to \"$RDIFF_OCTAVE_MKOCT\"
	echo
fi

if [ "$RDIFF_INTERPRETER" == 'matlab' ];
then
	echo Please enter the full path to matlab \(currently set to \"$MATLAB_BIN_PATH\", system version used, if left empty\)
	read MATLAB_BIN_PATH
	if [ "$MATLAB_BIN_PATH" == "" ];
	then
		MATLAB_BIN_PATH=`which matlab`
		if [ "$MATLAB_BIN_PATH" == "" ];
		then
			echo matlab not found
			exit -1
		fi
	fi
	if [ ! -f $MATLAB_BIN_PATH ];
	then
		echo matlab not found
		exit -1
	fi
	echo '=>' Setting matlab\'s path to \"$MATLAB_BIN_PATH\"
	echo

	echo Please enter the full path to mex binary \(currently set to \"$MATLAB_MEX_PATH\", system version used if left empty\)
	read MATLAB_MEX_PATH
	if [ "$MATLAB_MEX_PATH" == "" ];
	then
		MATLAB_MEX_PATH=`which mex`
		if [ "$MATLAB_MEX_PATH" == "" ];
		then
			echo mex not found
			exit -1
		fi
	fi
	if [ ! -f "$MATLAB_MEX_PATH" ];
	then
		echo mex not found
		exit -1
	fi
	echo '=>' Setting mex\' path to \"$MATLAB_MEX_PATH\"
	echo

	echo Please enter the full path to the matlab include directory \(currently set to \"$MATLAB_INCLUDE_DIR\", system version used, if left empty\)
	read MATLAB_INCLUDE_DIR
	if [ "$MATLAB_INCLUDE_DIR" == "" ];
	then
		MATLAB_INCLUDE_DIR=$(dirname $MATLAB_BIN_PATH)/../extern/include
	fi
	if [ ! -d "$MATLAB_INCLUDE_DIR" ];
	then
		echo matlab include dir not found
		exit -1
	fi
	echo '=>' Setting matlab\'s include directory to \"$MATLAB_INCLUDE_DIR\"
	echo

	RDIFF_OCTAVE_BIN_PATH=
fi

cp -p bin/rdiff_config.sh bin/rdiff_config.sh.bak

grep -v -e RDIFF_OCTAVE_BIN_PATH -e RDIFF_OCTAVE_MKOCT -e MATLAB_BIN_PATH -e MATLAB_MEX_PATH -e MATLAB_INCLUDE_DIR \
    -e RDIFF_PATH -e RDIFF_SRC_PATH -e RDIFF_BIN_PATH \
    -e RDIFF_INTERPRETER bin/rdiff_config.sh.bak \
    -e RDIFF_SAMTOOLS_BIN_DIR -e RDIFF_SAMTOOLS_LIB_DIR -e RDIFF_SAMTOOLS_INCLUDE_DIR -e RDIFF_PYTHON_PATH -e SCIPY_PATH -e $RDIFF_VERSION > bin/rdiff_config.sh

echo
echo
echo Generating config file ... 

# appending the relevant lines to rdiff_config.sh
echo export RDIFF_VERSION=$RDIFF_VERSION >> bin/rdiff_config.sh
echo export RDIFF_PATH=$RDIFF_PATH >> bin/rdiff_config.sh
echo export RDIFF_SRC_PATH=${RDIFF_PATH}/src >> bin/rdiff_config.sh
echo export RDIFF_BIN_PATH=${RDIFF_PATH}/bin >> bin/rdiff_config.sh
echo export RDIFF_INTERPRETER=$RDIFF_INTERPRETER >> bin/rdiff_config.sh
#echo export MATLAB_BIN_PATH=$MATLAB_BIN_PATH >> bin/rdiff_config.sh
#echo export MATLAB_MEX_PATH=$MATLAB_MEX_PATH >> bin/rdiff_config.sh
#echo export MATLAB_INCLUDE_DIR=$MATLAB_INCLUDE_DIR >> bin/rdiff_config.sh
echo export RDIFF_OCTAVE_BIN_PATH=$RDIFF_OCTAVE_BIN_PATH >> bin/rdiff_config.sh
echo export RDIFF_OCTAVE_MKOCT=$RDIFF_OCTAVE_MKOCT >> bin/rdiff_config.sh
echo export RDIFF_SAMTOOLS_BIN_DIR=$RDIFF_SAMTOOLS_BIN_DIR >> bin/rdiff_config.sh  
echo export RDIFF_SAMTOOLS_LIB_DIR=$RDIFF_SAMTOOLS_LIB_DIR >> bin/rdiff_config.sh  
echo export RDIFF_SAMTOOLS_INCLUDE_DIR=$RDIFF_SAMTOOLS_INCLUDE_DIR >> bin/rdiff_config.sh  
echo export RDIFF_PYTHON_PATH=$RDIFF_PYTHON_PATH >> bin/rdiff_config.sh

echo Done.
echo 

echo Please use \'make\' to compile the mex files before using rDiff.
echo To test rDiff use \'make test\'.
echo
