#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="lr-daphne"
rp_module_desc="Laserdisc emu - Daphne port for libretro"
rp_module_help="ROM Extension: .daphne\n\nCopy your Daphne roms to $romdir/daphne"
rp_module_section="exp"

function sources_lr-daphne() {
    gitPullOrClone "$md_build" https://github.com/libretro/daphne.git
}

function build_lr-daphne() {
    make clean
    make platform=pi -j4
    md_ret_require="$md_build/daphne_libretro.so"
}

function install_lr-daphne() {
    md_ret_files=(
        'daphne_libretro.so'
    )
}

function configure_lr-daphne() {
    mkRomDir "daphne"
    ensureSystemretroconfig "daphne"

    addEmulator 1 "$md_id" "daphne" "$md_inst/daphne_libretro.so"
    addSystem "daphne"
}
