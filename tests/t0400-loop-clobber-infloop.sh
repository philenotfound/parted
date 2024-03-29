#!/bin/sh
# do not infloop in loop_clobber

# Copyright (C) 2009-2013 Free Software Foundation, Inc.

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

. "${srcdir=.}/init.sh"; path_prepend_ ../parted

( mkswap -V ) >/dev/null 2>&1 || skip_ "no mkswap program"

N=1M
dev=loop-file
dd if=/dev/null of=$dev bs=1 seek=$N || fail=1

mkswap $dev || fail=1

# There was a small interval (no release) during which this would infloop.
# create a dos partition table
parted -s $dev mklabel msdos > out 2>&1 || fail=1

compare /dev/null out || fail=1

Exit $fail
