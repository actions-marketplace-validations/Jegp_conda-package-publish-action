#!/bin/bash

set -ex
set -o pipefail

go_to_build_dir() {
    if [ ! -z $INPUT_SUBDIR ]; then
        cd $INPUT_SUBDIR
    fi
}

check_if_setup_file_exists() {
    if [ ! -f setup.py ]; then
        echo "setup.py must exist in the directory that is being packaged and published."
        exit 1
    fi
}

check_if_meta_yaml_file_exists() {
    if [ ! -f meta.yaml ]; then
        echo "meta.yaml must exist in the directory that is being packaged and published."
        exit 1
    fi
}

build_package() {
    # Build for Linux
    conda mambabuild -c conda-forge --output-folder . .

    # Convert to other platforms: OSX, WIN
    if [[ $INPUT_PLATFORMS == *"osx"* ]]; then
        conda convert -p osx-64 linux-64/*.tar.bz2
    fi
    if [[ $INPUT_PLATFORMS == *"win"* ]]; then
        conda convert -p win-64 linux-64/*.tar.bz2
    fi
}

upload_package() {
    if [[ $INPUT_ANACONDATOKEN -ne "" ]]; then
        echo "Build complete, publishing to Anaconda with flags '${INPUT_PUBLISHFLAGS}'"
        if [[ $INPUT_PLATFORMS == *"osx"* ]]; then
            anaconda upload --label main $INPUT_PUBLISHFLAGS osx-64/*.tar.bz2
        fi
        if [[ $INPUT_PLATFORMS == *"linux"* ]]; then
            anaconda upload --label main -u $INPUT_PUBLISHFLAGS linux-64/*.tar.bz2
        fi
        if [[ $INPUT_PLATFORMS == *"win"* ]]; then
            anaconda upload --label main -u $INPUT_PUBLISHFLAGS win-64/*.tar.bz2
        fi
    else
        echo "Build complete, ignoring upload"
    fi
}

check_if_setup_file_exists
go_to_build_dir
check_if_meta_yaml_file_exists
build_package
upload_package
