#!/bin/sh
# parted 3.1 and prior would exit with no diagnostic when failing
# to create a GPT partition table on a device that was too small.

# Copyright (C) 2012-2013 Free Software Foundation, Inc.

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
require_512_byte_sector_size_

dev=loop-file
ss=$sector_size_

# Create the smallest file that can accommodate a GPT partition table.
dd if=/dev/null of=$dev bs=$ss seek=67 || framework_failure

# create a GPT partition table
parted -s $dev mklabel gpt > out 2>&1 || fail=1
# expect no output
compare /dev/null out || fail=1

# Create a file that is 1 sector smaller, and require failure,
# *with* a diagnostic.
rm -f $dev
dd if=/dev/null of=$dev bs=$ss seek=66 || framework_failure

echo Error: device is so small it cannot even accommodate GPT headers \
  > exp || framework_failure

# Try to create a GPT partition table in too little space.  This must fail.
parted -s $dev mklabel gpt > out 2>&1 && fail=1
# There must be a diagnostic.
compare exp out || fail=1

Exit $fail
