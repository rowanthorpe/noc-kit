NOC_KIT_VERSION=0.1

nk_exec_name="`echo "$0" | sed -r -e 's@^.*/([^/]+)$@\1@'`"

nk_usage_footer() {
	cat <<EOH

 Part of the NOC-Kit package.
 License AGPLv3+: GNU Affero GPL version 3 or later
 <http://gnu.org/licenses/agpl.html>.
 This is free software: you are free to change and redistribute it.
 There is NO WARRANTY, to the extent permitted by law.
EOH
}

nk_version() {
	echo "$nk_exec_name $VERSION - noc-kit $NOC_KIT_VERSION"
}

nk_info() {
	for nk_info_arg in "$@"; do
		[ "$nk_verbose" = 1 ] && echo "$nk_exec_name: $nk_info_arg"
	done
}

nk_warn() {
	nk_info "$@" >&2
}

nk_die() {
	if [ $# -eq 0 ]; then
		nk_exitval=1
	else
		nk_exitval=$1
		shift
		if [ $# -gt 0 ]; then
			nk_warn "$@"
		fi
	fi
	exit $nk_exitval
}

nk_die_u() {
	nk_die "$@" "Try \`$nk_exec_name --help' for details of the command."
}
