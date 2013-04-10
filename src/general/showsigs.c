#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <string.h>

void help(FILE *stream);
void version(FILE *stream, char *_version, char *nk_version);
int source(FILE *stream);

/* showsigs.c: Do nothing but override and warn when signals are received,
               except for SIGSTOP or SIGKILL (which can't be overriden).

 ----

 Copyright © 2012, 2013 Rowan Thorpe

 This file is part of NOC-Kit.

 NOC-Kit is free software: you can redistribute it and/or modify
 it under the terms of the GNU Affero General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 NOC-Kit is distributed in the hope that it will be useful,
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
	 * allow flags to configure which sigs to wait for (default: all)
     * find how to embed source for --source output
*/

int main(int argc, char *argv[]) {
	sigset_t sigs;
	int sig;
	char *_version = "0.2.0";
	char *nk_version = "0.2.0";
	int count;

	if (argc > 1)
		for (count = 1; count < argc; count++) {
			if (argv[count][0] != '-' || strncmp(argv[count], "--", 3) == 0)
				break;
			if (strncmp(argv[count], "-h", 3) == 0 || strncmp(argv[count], "--help", 7) == 0) {
				help(stdout);
				exit(0);
			}
			if (strncmp(argv[count], "-V", 3) == 0 || strncmp(argv[count], "--version", 10) == 0) {
				version(stdout, _version, nk_version);
				exit(0);
			}
			if (strncmp(argv[count], "-S", 3) == 0 || strncmp(argv[count], "--source", 9) == 0) {
				exit(source(stdout));
			}
			fprintf(stderr, "Invalid option specified: %s\n", argv[count]);
			exit(1);
		}

	printf("PID: %d\n", getpid());
	sigfillset(&sigs);

/*
 -- posix signals, for later use --
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
 -- misc signals according to wikipedia --
	sigaddset(&sigs, SIGEMT); -- not in my signals.h
	sigaddset(&sigs, SIGINFO); -- not in my signals.h
	sigaddset(&sigs, SIGPWR);
	sigaddset(&sigs, SIGLOST); -- not in my signals.h
	sigaddset(&sigs, SIGWINCH);
 -- other misc signals found elsewhere... --
	sigaddset(&sigs, SIGSTKFLT);
	sigaddset(&sigs, SIGIO);
*/

	sigprocmask(SIG_BLOCK, &sigs, NULL);
	while(1) {
		sigwait(&sigs, &sig);
		printf("Got signal: %d\n", sig);
	}
	sigprocmask(SIG_UNBLOCK, &sigs, NULL);

	exit(1);
}

void help(FILE *stream) {
	fprintf(stream, "%s\n", "Usage: showsigs [--help|-h] [--version|-V] [--source|-S] [--]\n\n Do nothing but override and warn when signals are received, except for SIGSTOP\n or SIGKILL (which can't be overridden).");
}
void version(FILE *stream, char *_version, char *nk_version) {
	fprintf(stream, "showsigs %s - noc-kit %s\nCopyright (C) 2012, 2013 Rowan Thorpe.\nLicense AGPLv3+: GNU AGPL version 3 or later <http://gnu.org/licenses/agpl.html>\nThis is free software: you are free to change and redistribute it.\nThere is NO WARRANTY, to the extent permitted by law.\n", _version, nk_version);
}
int source(FILE *stream) {
	char *mysource = "TODO: use make to insert source into mysource";
	fprintf(stream, "%s\n", mysource);
	return(0);
}
