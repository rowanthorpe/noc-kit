# nk_tests.sh:
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

if test -z "$__tests_sourced"; then
	__on() { eval $1=1; }
	__off() { unset $1; }
	__ison() { test "x$1" = x1; }
	__isoff() { ! __ison "$1"; }
	__eql() { test "x$1" = "x$2"; }
	__neq() { ! __eql "$1" "$2"; }
	__has() { printf "$2" | grep -F -q "$1"; }
	__empty() {
	    for __arg do
	        test -z "$__arg" || return 1
	    done
	    unset __arg
	}
	__notempty() {
	    for __arg do
	        test -n "$__arg" || return 1
	    done
	    unset __arg
	}

	__tests_cleanup() {
	    __cleanup \
"" \
" \
__on \
__off \
__ison \
__isoff \
__eql \
__neq \
__has \
__empty \
__notempty \
" \
"" \
""
	    unset -f __cleanup
    	unset -f __tests_cleanup
	}
	__tests_sourced=1
fi
