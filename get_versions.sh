#! /bin/bash

version=$1
echo -n " "

function check_for_curl() {
    if ! command -v curl &> /dev/null
    then
        echo "curl could not be found"
        exit
    fi
}
function check_for_jq() {
    if ! command -v jq &> /dev/null
    then
        echo "jq could not be found"
        exit
    fi
}

function get_latest_version() {
    build_version=$(curl -sSL https://api.papermc.io/v2/projects/velocity | jq -r ".versions[-1]")
    echo "$build_version"
}

function download_latest_build() {
    build_version=$1
    build_number=$(curl -sSL https://api.papermc.io/v2/projects/velocity/versions/"$build_version"/builds | jq -r ".builds[-1].build")
    echo -n "$build_number"
    curl -sSL https://api.papermc.io/v2/projects/velocity/versions/"$build_version"/builds/"$build_number"/downloads/velocity-"$build_version"-"$build_number".jar -o velocity.jar
}

check_for_curl
check_for_jq

if [ "$version" == "latest" ]; then
    echo -n "latest "
fi

if [ -z "$version" ]; then
    version=$(get_latest_version)
fi

build_num=$(download_latest_build "$version")

echo "$version $version-$build_num"
