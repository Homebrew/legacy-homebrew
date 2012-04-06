require 'formula'

class Watch < Formula
  homepage 'http://procps.sourceforge.net/'
  url 'http://procps.sourceforge.net/procps-3.2.8.tar.gz'
  md5 '9532714b6846013ca9898984ba4cd7e0'

  def patches
    # from debian
    [ "http://patch-tracker.debian.org/patch/series/dl/procps/1:3.2.8-9/watch.1.patch",
    "http://patch-tracker.debian.org/patch/series/dl/procps/1:3.2.8-9/watch_8bitchar.patch",
    "http://patch-tracker.debian.org/patch/series/dl/procps/1:3.2.8-9/watch_exec_beep.patch",
    "http://patch-tracker.debian.org/patch/series/dl/procps/1:3.2.8-9/watch_precision_time.patch",
    # the following patch modified from http://patch-tracker.debian.org/patch/series/dl/procps/1:3.2.8-9/watch_ansi_colour.patch
    # modified because we are skipping unicode patch as it includes ncursesw
    DATA
    ]
  end

  def install
    system "make", "watch", "PKG_LDFLAGS=-Wl"
    bin.install "watch"
    man1.install "watch.1"
  end
end

__END__
Description: Interprets ANSI color code sequences
Bug-Debian: http://bugs.debian.org/129334
Author: Craig Small <csmall@debian.org>
Last-Update: 2010-03-01
--- a/watch.c
+++ b/watch.c
@@ -37,6 +37,7 @@
 #endif
 
 static struct option longopts[] = {
+  {"color", no_argument, 0, 'c' },
 	{"differences", optional_argument, 0, 'd'},
 	{"help", no_argument, 0, 'h'},
 	{"interval", required_argument, 0, 'n'},
@@ -50,7 +51,7 @@
 };
 
 static char usage[] =
-    "Usage: %s [-bdhnptvx] [--beep] [--differences[=cumulative]] [--exec] [--help] [--interval=<n>] [--no-title] [--version] <command>\n";
+    "Usage: %s [-bcdhnptvx] [--beep] [--color] [--differences[=cumulative]] [--exec] [--help] [--interval=<n>] [--no-title] [--version] <command>\n";
 
 static char *progname;
 
@@ -62,6 +63,74 @@
 static int precise_timekeeping = 0;
 
 #define min(x,y) ((x) > (y) ? (y) : (x))
+#define MAX_ANSIBUF 10
+
+static void init_ansi_colors(void)
+{
+  int i;
+  short ncurses_colors[] = {
+    COLOR_BLACK, COLOR_RED, COLOR_GREEN, COLOR_YELLOW, COLOR_BLUE,
+    COLOR_MAGENTA, COLOR_CYAN, COLOR_WHITE };
+
+  for (i=0; i< 8; i++)
+    init_pair(i+1, ncurses_colors[i], -1);
+}
+
+static void set_ansi_attribute(const int attrib)
+{
+  switch (attrib)
+  {
+    case -1:
+      return;
+    case 0:
+      standend();
+      return;
+    case 1:
+      attrset(A_BOLD);
+      return;
+  }
+  if (attrib >= 30 && attrib <= 37) {
+    color_set(attrib-29,NULL);
+    return;
+  }
+}
+
+static void process_ansi(FILE *fp)
+{
+  int i,c, num1, num2;
+  char buf[MAX_ANSIBUF];
+  char *nextnum;
+
+
+  c= getc(fp);
+  if (c != '[') {
+    ungetc(c, fp);
+    return;
+  }
+  for(i=0; i<MAX_ANSIBUF; i++)
+  {
+    c = getc(fp);
+    if (c == 'm') //COLOUR SEQUENCE ENDS in 'm'
+    {
+      buf[i] = '\0';
+      break;
+    }
+    if (c < '0' && c > '9' && c != ';')
+    {
+      while(--i >= 0)
+        ungetc(buf[i],fp);
+      return;
+    }
+    buf[i] = (char)c;
+  }
+  num1 = strtol(buf, &nextnum, 10);
+  if (nextnum != buf && nextnum[0] != '\0')
+    num2 = strtol(nextnum+1, NULL, 10);
+  else
+    num2 = -1;
+  set_ansi_attribute(num1);
+  set_ansi_attribute(num2);
+}
 
 static void do_usage(void) NORETURN;
 static void do_usage(void)
@@ -187,6 +256,7 @@
 	    option_differences_cumulative = 0,
 			option_exec = 0,
 			option_beep = 0,
+      option_color = 0,
         option_errexit = 0,
 	    option_help = 0, option_version = 0;
 	double interval = 2;
@@ -205,12 +275,15 @@
 	setlocale(LC_ALL, "");
 	progname = argv[0];
 
-	while ((optc = getopt_long(argc, argv, "+bed::hn:pvtx", longopts, (int *) 0))
+	while ((optc = getopt_long(argc, argv, "+bced::hn:pvtx", longopts, (int *) 0))
 	       != EOF) {
 		switch (optc) {
 		case 'b':
 			option_beep = 1;
 			break;
+    case 'c':
+      option_color = 1;
+      break;
 		case 'd':
 			option_differences = 1;
 			if (optarg)
@@ -319,6 +392,14 @@
 	/* Set up tty for curses use.  */
 	curses_started = 1;
 	initscr();
+  if (option_color) {
+    if (has_colors()) {
+      start_color();
+      use_default_colors();
+      init_ansi_colors();
+    } else
+      option_color = 0;
+  }
 	nonl();
 	noecho();
 	cbreak();
@@ -360,7 +441,13 @@
 						}while (c != EOF && !isprint(c)
 						       && wcwidth(c) == 0
 						       && c != '\n'
-						       && c != '\t');
+						       && c != '\t'
+                   && (c != '\033' || option_color != 1));
+          if (c == '\033' && option_color == 1) {
+            x--;
+            process_ansi(p);
+            continue;
+          }
 					if (c == '\n')
 						if (!oldeolseen && x == 0) {
 							x = -1;
--- a/watch.1
+++ b/watch.1
@@ -1,4 +1,4 @@
-.TH WATCH 1 "2009 May 11" " " "Linux User's Manual"
+.TH WATCH 1 "2010 Mar 01" " " "Linux User's Manual"
 .SH NAME
 watch \- execute a program periodically, showing output fullscreen
 .SH SYNOPSIS
@@ -8,6 +8,7 @@
 .RB [ \-n
 .IR seconds ]
 .RB [ \-\-beep ]
+.RB [ \-\-color ]
 .RB [ \-\-differences[=\fIcumulative\fP]]
 .RB [ \-\-errexit ]
 .RB [ \-\-exec ]
@@ -75,6 +76,10 @@
 options, which will cause
 .B watch
 to exit if the return value from the program is non-zero.
+.PP
+By default \fBwatch\fR will normally not pass escape characters, however
+if you use the \fI\-\-c\fR or \fI\-\-color\fR option, then
+\fBwatch\fR will interpret ANSI color sequences for the foreground.
 
 .SH NOTE
 Note that
