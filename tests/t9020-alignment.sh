#!/bin/sh
# verify that new alignment-querying functions work

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

require_root_
require_scsi_debug_module_

grep '^#define USE_BLKID 1' "$CONFIG_HEADER" > /dev/null ||
  skip_ 'this system lacks a new-enough libblkid'

cat <<EOF > exp || framework_failure
minimum: 7 8
optimal: 7 2048
partition alignment: 0 1
EOF

# create memory-backed device
scsi_debug_setup_ physblk_exp=3 lowest_aligned=7 num_parts=4 > dev-name ||
  skip_ 'failed to create scsi_debug device'
scsi_dev=$(cat dev-name)

# print alignment info
"$abs_srcdir/print-align" $scsi_dev > out 2>&1 || fail=1

compare exp out || fail=1

Exit $fail
