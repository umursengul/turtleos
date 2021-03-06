#!/bin/bash -e

# Font styles
GREEN="\e[1;38;5;40m"
BOLD="\e[1m"
RST="\e[0m"

export IMG_NAME='turtleos'
export DEBIAN_FRONTEND='noninteractive'
export LC_ALL='C.UTF-8'

if [ -n "${TRAVIS_TAG:-}" ]; then
	export IMG_DATE="$TRAVIS_TAG"
fi

cd "$(dirname "$0")"
mkdir -p build
cd build

merge () {
    # Merge overlay with the original pi-gen
    echo -e " Merging overlay with the original pi-gen"
    cp -rf ../pi-gen/* .
    rm -rf stage2/EXPORT_NOOBS stage2/EXPORT_IMAGE stage3 stage4 stage5
    cp -rf ../pi-gen-overlay/* .
}

case "$1" in
    -s) echo -e "$BOLD Performing build of $GREEN$IMG_NAME$RST..."
        echo -e "$BOLD Skipping all stages except stage3$RST"

        merge

        for STAGE_DIR in "stage"*; do
            if [ "$STAGE_DIR" != stage3 ]; then
                echo " + Adding SKIP file to $STAGE_DIR"
                touch $STAGE_DIR/SKIP
            fi
        done
        echo -en " "
        for i in {76..81} {81..76} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo

        CLEAN=1 ./build.sh
        ;;
    *) echo -e "$BOLD Performing build of $GREEN$IMG_NAME$RST..."
       echo -e "$BOLD Building all stages except$RST"

        merge

        for STAGE_DIR in "stage"*; do
            echo "- Removing SKIP* file in $STAGE_DIR"
            rm -f $STAGE_DIR/SKIP*
        done

        ./build.sh
        ;;
esac
