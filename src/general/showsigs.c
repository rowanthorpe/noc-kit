#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

/* showsigs.c: Do nothing but override and warn when signals are received,
               except for SIGSTOP or SIGKILL (which can't be overriden).

 Copyright © 2012 Rowan Thorpe

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU Affero General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this program. If not, see <http://www.gnu.org/licenses/>.

 ----

 For bug-reports please email: rowan *at* rowanthorpe _DOT_ com
 (obviously, fix the address with the appropriate symbols and no spaces).

*/

/*
	TODO:
	 * --help output
	 * allow flags to configure which sigs to wait for (default: all)
*/

int main(void) {
	sigset_t sigs;
	int sig;

	printf("PID: %d\n", getpid());
	sigemptyset(&sigs);

/* -- posix signals -- */
	sigaddset(&sigs, SIGABRT);
	sigaddset(&sigs, SIGALRM);
	sigaddset(&sigs, SIGVTALRM);
	sigaddset(&sigs, SIGPROF);
	sigaddset(&sigs, SIGBUS);
	sigaddset(&sigs, SIGCHLD);
	sigaddset(&sigs, SIGCONT);
	sigaddset(&sigs, SIGFPE);
	sigaddset(&sigs, SIGHUP);
	sigaddset(&sigs, SIGILL);
	sigaddset(&sigs, SIGINT);
	sigaddset(&sigs, SIGPIPE);
	sigaddset(&sigs, SIGQUIT);
	sigaddset(&sigs, SIGSEGV);
	sigaddset(&sigs, SIGTERM);
	sigaddset(&sigs, SIGTSTP);
	sigaddset(&sigs, SIGTTIN);
	sigaddset(&sigs, SIGTTOU);
	sigaddset(&sigs, SIGUSR1);
	sigaddset(&sigs, SIGUSR2);
	sigaddset(&sigs, SIGPOLL);
	sigaddset(&sigs, SIGSYS);
	sigaddset(&sigs, SIGTRAP);
	sigaddset(&sigs, SIGURG);
	sigaddset(&sigs, SIGXCPU);
	sigaddset(&sigs, SIGXFSZ);
	sigaddset(&sigs, SIGRTMIN);
	sigaddset(&sigs, SIGRTMIN+1);
	sigaddset(&sigs, SIGRTMIN+2);
	sigaddset(&sigs, SIGRTMIN+3);
	sigaddset(&sigs, SIGRTMIN+4);
	sigaddset(&sigs, SIGRTMIN+5);
	sigaddset(&sigs, SIGRTMIN+6);
	sigaddset(&sigs, SIGRTMIN+7);
	sigaddset(&sigs, SIGRTMIN+8);
	sigaddset(&sigs, SIGRTMIN+9);
	sigaddset(&sigs, SIGRTMIN+10);
	sigaddset(&sigs, SIGRTMIN+11);
	sigaddset(&sigs, SIGRTMIN+12);
	sigaddset(&sigs, SIGRTMIN+13);
	sigaddset(&sigs, SIGRTMIN+14);
	sigaddset(&sigs, SIGRTMIN+15);
	sigaddset(&sigs, SIGRTMAX-14);
	sigaddset(&sigs, SIGRTMAX-13);
	sigaddset(&sigs, SIGRTMAX-12);
	sigaddset(&sigs, SIGRTMAX-11);
	sigaddset(&sigs, SIGRTMAX-10);
	sigaddset(&sigs, SIGRTMAX-9);
	sigaddset(&sigs, SIGRTMAX-8);
	sigaddset(&sigs, SIGRTMAX-7);
	sigaddset(&sigs, SIGRTMAX-6);
	sigaddset(&sigs, SIGRTMAX-5);
	sigaddset(&sigs, SIGRTMAX-4);
	sigaddset(&sigs, SIGRTMAX-3);
	sigaddset(&sigs, SIGRTMAX-2);
	sigaddset(&sigs, SIGRTMAX-1);
	sigaddset(&sigs, SIGRTMAX);
/* -- misc signals according to wikipedia -- */
	/* sigaddset(&sigs, SIGEMT); -- not in my signals.h */
	/* sigaddset(&sigs, SIGINFO); -- not in my signals.h */
	sigaddset(&sigs, SIGPWR);
	/* sigaddset(&sigs, SIGLOST); -- not in my signals.h */
	sigaddset(&sigs, SIGWINCH);
/* -- other misc signals found elsewhere... -- */
	sigaddset(&sigs, SIGSTKFLT);
	sigaddset(&sigs, SIGIO);

	sigprocmask(SIG_BLOCK, &sigs, NULL);
	while(1) {
		sigwait(&sigs, &sig);
		printf("Got signal: %d\n", sig);
	}
	sigprocmask(SIG_UNBLOCK, &sigs, NULL);

	exit(1);
}

