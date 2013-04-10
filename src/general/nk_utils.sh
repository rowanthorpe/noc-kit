# nk_utils.sh:
#
# NB: This aims to be POSIX.1-2008 compliant
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

if test -z "$__utils_sourced"; then
	__scriptname="$(readlink -q -e -n "$0")"
	__scriptbasename="${__scriptname##*/}"
	__scriptdirname="${__scriptname%/*}"

	. "${__root_dir}/nk_tests.sh" || { printf %s\\n "Failed to load nk_tests.sh"; exit 1; }
#	. "${__root_dir}/nk_lists.sh" || { printf %s\\n "Failed to load nk_lists.sh"; exit 1; } #TODO

	__usage_footer() {
		cat <<EOH

 Part of the NOC-Kit package.
 License AGPLv3+: GNU Affero GPL version 3 or later
 <http://gnu.org/licenses/agpl.html>.
 This is free software: you are free to change and redistribute it.
 There is NO WARRANTY, to the extent permitted by law.
EOH
	}
	__version() { printf "%s %s - noc-kit %s\n" "$__scriptbasename" "$VERSION" "$NOC_KIT_VERSION"; }
	__usage() { true; } # to override
	__info() { for i; do printf %s\\n "${__scriptbasename}: $i"; done; }
	__warn() { __info "$@" >&2; }
	__die() {
    	if test "x$1" = "x-u"; then __usage >&2; shift; fi
		if test "x$1" = "x--"; then	shift; fi
		if test $# = 0; then
			__exitval=1
		else
			if test $# -gt 1; then
				__exitval=$1
				shift
			else
				__exitval=1
			fi
			printf \\n >&2
			__warn "$@" "Exiting."
		fi
		exit $__exitval
	}
	__lambda() {
	    test $# = 2 || { printf %s\\n "Syntax error in __lambda()" >&2; return 1; }
	    __lambda_vars="$(printf %s "$1" | tr "," " ")"
	    __lambda_varsnum="$(printf %s "$__lambda_vars" | wc -w)"
	    __lambda_cmd="$2"
	    printf %s \
'__lambda_func() {
    test $# = "'"$__lambda_varsnum"'" || { printf %s\\n "Syntax error: __lambda() requires '"$__lambda_varsnum"' arguments" >&2; return 1; }
    __lambda_func_vars="'"$__lambda_vars"'"
    __lambda_func_cmd="'"$__lambda_cmd"'"
    __lambda_func_cnt=1
    for __lambda_func_var in $__lambda_func_vars
    do
        eval __lambda_func_replacement=\"\$$__lambda_func_cnt\"
        __lambda_func_cmd="$(printf %s "$__lambda_func_cmd" | sed -e "s/\<$__lambda_func_var\>/_-_lambda{_${__lambda_func_replacement}_}lambda_-_/g")"
        __lambda_func_cnt=`expr $__lambda_func_cnt + 1`
    done
    __lambda_func_cmd="$(printf %s "$__lambda_func_cmd" | sed -e "s/_-_lambda{_//g; s/_}lambda_-_//g")"
    unset __lambda_func_vars
    unset __lambda_func_cnt
    unset __lambda_func_var
    unset __lambda_func_replacement
    eval "$__lambda_func_cmd"
}
unset __lambda_vars
unset __lambda_varsnum
unset __lambda_cmd
__lambda_func'
	}
	__map() {
	    __map_cmd="$1"
	    shift
	    if __notempty "$@"; then
	        for __arg do
	            eval "$__map_cmd" \""$__arg"\"
	        done
			unset __map_cmd
			unset __arg
	    fi
	}
#	__filter() {} #TODO
#	__reduce() {} #TODO
	__cleanup() {
	    __map unset $1
	    __map "unset -f" $2
	    __map unalias $3
	    shift 3
	    __map "rm -fR" "$@" 2>/dev/null
	}

	__utils_cleanup() {
		__cleanup \
"" \
"__scriptname \
__scriptbasename \
__scriptdirname" \
__usage_footer \
__version \
__usage \
__info \
__warn \
__die \
__filter \
__reduce \
__list_create \
__list_destroy \
__list_append \
__list_prepend \
__list_insert \
__list_pop \
__list_shift \
__list_splice \
__list_length \
__list_iterate \
__list_slice \
__list_reverse \
__list_sort \
__lambda \
__map
"" \
""
		unset -f __cleanup
		unset -f __utils_cleanup
	}
	__utils_sourced=1
fi
