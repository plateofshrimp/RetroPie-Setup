#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

# TODO will this poison the namespace?
platform="apple2"

rp_module_id="gsplus"
rp_module_desc="Apple IIgs emulator"
rp_module_help="ROM Extensions: .dsk .po .2mg\n\nCopy your Apple II games to $romdir/$platform"
rp_module_licence="GNU GPL"
rp_module_repo="git https://github.com/yoyodyne-research/GSplus retropie"
rp_module_section="exp"
rp_module_flags=""

function depends_gsplus() {
    local depends=(cmake libreadline-dev re2c "$@")

    getDepends "${depends[@]}"
}

function sources_gsplus() {
    local revision="$1"
    [[ -d "$md_build" ]] && return
    git clone "$md_repo_url" "$md_build"
}

function build_gsplus() {
    local params=()

    # add or override params from calling function
    params+=("$@")

    #    mkdir -p build/bin && cp /home/ray/Developer/gsplus/build/bin/GSplus build/bin

    [[ -d build ]] && rm -rf build
    mkdir build && cd build && cmake .. && make -j 3
    md_ret_require="$md_build"
}

function install_gsplus() {
    install -d $md_inst/bin
    install build/bin/GSplus "$md_inst/bin/gsplus"
    cd etc/retropie && make install
    md_ret_require="$md_inst/bin/$rp_module_id"
}

function configure_gsplus() {
    local def=0
    local launcher_name="+Start GSplus.sh"
    local config_dir="$romdir/$platform"

    mkRomDir "$platform"

    addEmulator "$def" "$md_id" "$platform" "bash $romdir/$platform/${launcher_name// /\\ } %ROM%"
    addSystem "$platform"

#    rm -f "$romdir/$platform/$launcher_name"
#    [[ "$md_mode" == "remove" ]] && return
    if [ ! -f "$romdir/$platform/$launcher_name" ]
    then
	install etc/retropie/gsplus.sh "$romdir/$platform/$launcher_name"
	chmod +x "$romdir/$platform/$launcher_name"
	chown $user:$user "$romdir/$platform/$launcher_name"
    fi
}
