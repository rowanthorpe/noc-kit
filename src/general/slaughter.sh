#!/bin/sh

# slaughter.sh: see --help option for details
#
###########
#
# Copyright © 2012 Rowan Thorpe
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
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
nk_prefix=/usr/local
nk_root_dir=${nk_prefix}/libexec/noc-kit
VERSION=0.1
. "${nk_root_dir}/shell_common.sh" || {
	echo "Failed sourcing shell_common.sh. Stopping.">&2
	exit 1
}

# Functions
nk_usage() {
	cat <<EOH
Usage: slaughter.sh [OPTIONS] procnum [procnum] ...
       slaughterall.sh [OPTIONS] procname [procname] ...

Try to "kill" a process gently, then not-so-gently, if necessary.
 * By default does "kill -s 15" three times with a sleep 1, then
   "kill -9" with a sleep 1.
 * For slaughterall.sh each arg the command name (without options, etc)
 * if invoked as slaughterall (e.g. via symlink) acts analogously
   to killall vs. kill.

OPTIONS:
 --help|-h|--usage    : This help page.
 --version|-V|--about : Output information about this command.
 --source|-S          : Output this command as source code.
 --duration|-d        : Sleep duration between kill invocations.
 --repetitions|-r     : How many times to try try -15 before -9.
 --pattern|-p         : TODO: Explicitly set pattern of signals.
                        Overrides -r and -d. Follows 'sig,dur,...'
                        format (e.g. -p '15,1,15,2,15,2,9,1')
 --quiet|-q           : Don't output progress.
 --                   : End option processing.

 Copyright © 2012 Rowan Thorpe.
 Report bugs to rowan *at* rowanthorpe _DOT_ com
EOH
	nk_usage_footer
}

# Getopts
nk_duration=1
nk_repetitions=3
nk_verbose=1
while [ -n "$1" ]; do
	case "$1" in
	--help|-h|--usage)
		nk_usage
		exit 0
		;;
	--version|-V|--about)
		nk_version
		exit 0
		;;
	--source|-S)
		cat "$0"
		exit 0
		;;
	--duration|-d)
		if [ -z "$2" ] || printf "$2" | grep -q '[^0-9]' || [ $2 -gt 255 ] || [ $2 -lt 1 ]; then
			nk_die_u 253 "Invalid argument given for: duration."
		fi
		nk_duration="$2"
		shift 2
		continue
		;;
	--repetitions|-r)
		if [ -z "$2" ] || printf "$2" | grep -q '[^0-9]' || [ $2 -gt 255 ] || [ $2 -lt 1 ]; then
			nk_die_u 253 "Invalid argument given for: repetitions."
		fi
		nk_repetitions="$2"
		shift 2
		continue
		;;
#	--pattern|-p)
#		TODO: Explicitly set pattern of signals.
#		      Overrides -r and -d. Follows 'sig,dur,...'
#		      format (e.g. -p '15,1,15,2,15,2,9,1')
#		;;
	--quiet|-q)
		nk_verbose=0
		shift
		continue
		;;
	--)
		shift
		break
		;;
	-*)
		nk_die_u 254 "Unrecognised option specified."
		;;
	*)
		break
		;;
	esac
done

# Setup
nk_ret=0
nk_exit_val=0
nk_count=0
case "$nk_exec_name" in
slaughter|slaughter.sh)
	nk_kill_cmd() {
		kill -s "$@"
	}
	nk_check_cmd() {
		ps -p "$@"
	}
	nk_id_type=procid
	;;
slaughterall|slaughterall.sh)
	nk_kill_cmd() {
		killall -s "$@"
	}
	nk_check_cmd() {
		pgrep -c "^${@}\$"
	}
	nk_id_type=procname
	;;
*)
	nk_die_u 255 "Command form $nk_exec_name unknown"
	;;
esac

# Main
for nk_arg in "$@"; do
	nk_check_cmd "$nk_arg" >/dev/null 2>&1 || {
		nk_warn "$nk_id_type $nk_arg doesn't exist"
		nk_exitval=1
		continue 1
	}
	while [ $nk_count -lt $nk_repetitions ]; do
		nk_kill_cmd 15 "$nk_arg" >/dev/null 2>&1
		sleep $nk_duration
		nk_check_cmd "$nk_arg" >/dev/null 2>&1 || {
			nk_warn "Succeeded: nk_kill_cmd 15 \"$nk_arg\""
			continue 2
		}
		nk_warn "Failed: nk_kill_cmd 15 \"$nk_arg\""
		nk_count=$(( nk_count+1 ))
	done
	nk_kill_cmd 9 "$nk_arg" >/dev/null 2>&1
	sleep $nk_duration
	if nk_check_cmd "$nk_arg" >/dev/null 2>&1; then
		nk_die 1 "Failed: nk_kill_cmd 9 \"$nk_arg\""
		nk_exitval=1
	else
		nk_warn "Succeeded: nk_kill_cmd 9 \"$nk_arg\""
	fi
done
exit $nk_exitval
