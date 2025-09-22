#!/bin/sh
SELF_DIR="$( cd "$(dirname "$0")" ; pwd -P )"
BASE_DIR="$( cd "$SELF_DIR/../base" ; pwd -P )"

# This script tries to autodetect the platform and run the correct envsetup script(s)

. "$BASE_DIR/_common.sh"

usage() {
        echo usage: `basename $0` '[script]' 1>&2
        echo Autodetects the platform and runs the passed script for that platform.
        echo If no script specified will attempt to run all scripts for platform.
        exit 1
}

PASSED_SCRIPT=""
KERNEL_NAME=`uname -s`
DIR_FOR_PLATFORM="unknown"

while :
do
    case "$1" in
        -*) usage;;
        *) PASSED_SCRIPT="$1"; break;;
    esac
done

detect_platform_dir

if [ "$DIR_FOR_PLATFORM" != "unknown" ]; then
    echo "AUTO: using platform directory '$DIR_FOR_PLATFORM'"
    if [ -d "$DIR_FOR_PLATFORM" ]; then
        if [ "$PASSED_SCRIPT" != "" ]; then
            SCRIPT_PATH="$DIR_FOR_PLATFORM/$PASSED_SCRIPT"
            if [ -f "$SCRIPT_PATH" ]; then
                echo "AUTO: running script '$SCRIPT_PATH'"
                $SCRIPT_PATH
            else
                echo "AUTO: script '$SCRIPT_PATH' does not exist"
                exit 1
            fi
        else
            echo "AUTO: no script passed, running all scripts in directory '$DIR_FOR_PLATFORM'"
            for i in `ls $DIR_FOR_PLATFORM`
            do
                SCRIPT_PATH="$DIR_FOR_PLATFORM/$i"
                echo "AUTO: running script '$SCRIPT_PATH'"
                $SCRIPT_PATH
            done
        fi
    else
        echo "AUTO: could not find a directory with the name '$DIR_FOR_PLATFORM'"
        exit 1
    fi
else
    echo "AUTO: could not properly detect the platform, please run by hand or fix this scripts."
    exit 1
fi
