#!/bin/sh

# zfd.sh: see --help option for details
#
###########
#
# Copyright © 2012, 2013 Rowan Thorpe
#
# This file is part of NOC-Kit.
#
# NOC-Kit is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# NOC-Kit is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.
#
###########
#
# For bug-reports please email: rowan *at* rowanthorpe _DOT_ com
# (obviously, fix the address with the appropriate symbols and no spaces).

# Config
__prefix=/usr/local
__root_dir=${__prefix}/libexec/noc-kit
VERSION=0.2.0
. "${__root_dir}/nk_utils.sh" || {
	echo "Failed sourcing nk_utils.sh. Stopping.">&2
	exit 1
}

__usage() {
	cat <<EOH
Usage: $__scriptbasename "block_device" "device_nickname" [datetime]

POSIX shell script to quickly zero-out good sectors (only) on a failing disk.

  * specify datetime to resume previous invocation of that instance
    (format: %Y_%m_%d-%H_%M_%S)

DESCRIPTION:

 Zero Failing Disk (zfd) is a POSIX shell script to quickly zero-out good
 sectors on a failing disk while efficiently skipping bad sectors (to avoid
 triggering hardware bad-sector reallocation). It is most useful for server
 administrators returning failing disks under warranty, who wish to protect
 their clients' privacy. It does up to three zeroing passes, at three
 increasing levels of thoroughness:

 1) fast: merely skipping any clusters of sectors which have a problem
 2) splitting: splits problem clusters of sectors into good and bad sectors
 3) retrying: retries reading each bad sector two more times

 * Practically there is almost never any point to the third pass, as you want
   to avoid writing to a sector which even has the potential to be "bad" at
   the time of writing, so the third pass is disabled by default.
 * It must be run as root for low-level access to the disk.
 * Everything is interruptible/resumable as long as you leave the log-files in
   place.

 ZFD uses GNU ddrescue to do the heavy-lifting.

TODO:

 * Handle more POSIX systems for on-the-fly downloading of ddrescue (presently
   only Debian based systems are dealt with).

 * Use blktool, hdparm, raw devices, etc to avoid readahead confusing things
   (for people which --direct doesn't work for?).

 * Allow more fine-tuned handling of permissions, rather than just running the
   whole script as root.

EOH
}
setup() {
	test "`id -u`" = 0 || __die -u "Must be run as root"
	test $# = 2 || test $# = 3 || __die -u "You must specify the device-path and filename prefix (and optional datetime)"
	block_device="$1"
	device_nickname="$2"
	date_time="$3"
	test -b "$block_device" || __die -u "\"$_block_device\" appears not to be a block device"
	printf %s "$device_nickname" | grep -q '[^a-zA-Z0-9_]' || __die -u "\"$_device_nickname\" includes invalid characters ([^a-zA-Z0-9_])"
	if test -n "$date_time"; then
		logdir="log-${device_nickname}-${date_time}"
		test -d "$logdir" && test -r "$logdir" && test -w "$logdir" || __die -u "\"$logdir\" is not a read-writable directory"
	else
		logdir="log-${device_nickname}-`date +%Y_%m_%d-%H_%M_%S`" || __die -u "Problem invoking \"date\""
		! test -e "$logdir" || __die "\"$logdir\" already exists"
		mkdir "$logdir" || __die "Problem creating \"$logdir\""
		echo "Completed phases:">"${logdir}/progress.log"
	fi
}
phase_done() {
	grep -q "^$1\$" "${logdir}/progress.log"
}
ddrescue_pkg() {
	phase="ddrescue_pkg_$1"
	if ! phase_done "$phase"; then
		if test -e /etc/debian_version; then
			# On a Debian (based) system...
			case "$1" in
			install)
				if ! dpkg -l gddrescue >/dev/null 2>&1; then
					apt-get install gddrescue || __die "Unable to install gddrescue"
				fi;;
			purge)
				if ! installed = "`dpkg --get-selections gddrescue | sed -e 's/^.*\t\([^ \t]\+\)$/\1/'`"; then
					apt-get purge gddrescue || __die "Unable to purge temporarily installed gddrescue"
				fi;;
			esac
		fi
		echo "$phase" >>"${logdir}/progress.log"
	fi
}
fake_rescue() {
	## do fake "rescue" to /dev/null, logging status of sectors
	phase_type="fake_rescue"
	phase_category="$1"
	case "$phase_category" in
	splitting) prev_phase_category=fast;;
	retrying) prev_phase_category=splitting;;
	esac
	phase="${phase_type}_$phase_category"
	if ! phase_done "$phase"; then
		flags='-f -S'
		case "$phase_category" in
		fast) flags="$flags -n";;
		splitting|retrying)
			flags="$flags -d -b 512"
			case "$phase_category" in
			splitting) flags="$flags -r 0 -A";;
			retrying) flags="$flags -r 2";;
			esac
			test -e "${logdir}/${phase}.log" || cp "${logdir}/${phase_type}_${prev_phase_category}.log" "${logdir}/${phase}.log" || __die "Problem copying logfiles";;
		esac
		eval ddrescue $flags \"\$block_device\" /dev/null \"\${logdir}/\${phase}.log\"
		test ! ddrescuelog -D "${logdir}/${phase}.log" || echo "$phase" >>"${logdir}/progress.log"
	fi
}
zero_fill() {
	## copy fake_rescue log to zero_fill log, do reverse "rescue" from /dev/zero to device, zeroing "+" sectors from zero_fill log (zero good sectors only)
	phase_type="zero_fill"
	phase_category="$1"
	case "$phase_category" in
	splitting) prev_phase_category=fast;;
	retrying) prev_phase_category=splitting;;
	esac
	phase="${phase_type}_$phase_category"
	if ! phase_done "$phase"; then
		flags='-f -R -C -F "+"'
		case "$phase_category" in
		fast) flags="$flags -n";;
		splitting|retrying) flags="$flags -d -r 0 -b 512";;
		esac
		if ! test -e "${logdir}/${phase}.log"; then
			case "$phase_category" in
			fast) cp "${logdir}/fake_rescue_${phase_category}.log" "${phase}.log" || __die "Problem copying logfiles";;
			splitting|retrying) ddrescuelog -x "${logdir}/fake_rescue_${prev_phase_category}.log" "${logdir}/fake_rescue_${phase_category}.log" >"${logdir}/${phase}.log"
			esac
		fi
		eval ddrescue $flags \"\$block_device\" /dev/null \"\${logdir}/\${phase}.log\"
		ddrescuelog -d "${logdir}/${phase}.log"
		test -e "${logdir}/${phase}.log" || echo "$phase" >>"${logdir}/progress.log"
	fi
}

while test -n "$1"; do
	case "$1" in
	--help|--usage|-h) usage; exit 0;;
	--version|-V) __version;;
	esac
setup "$@"
ddrescue_pkg "install"
for phase_type in fast splitting retrying; do
	fake_rescue "$phase_type"
	zero_fill "$phase_type"
done
ddrescue_pkg "purge"
