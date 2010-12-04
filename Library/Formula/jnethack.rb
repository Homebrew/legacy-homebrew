require 'formula'

# Nethack the way God intended it to be played: from a terminal.

# This formula is based on Nethack formula.
# The patches in DATA section are shamelessly stolen from MacPorts' jnethack portfile.

class Jnethack <Formula
  url 'http://downloads.sourceforge.net/project/nethack/nethack/3.4.3/nethack-343-src.tgz'
  homepage 'http://jnethack.sourceforge.jp/'
  version '3.4.3-0.10'
  md5 '21479c95990eefe7650df582426457f9'

  # Don't remove save folder
  skip_clean 'libexec/save'

  def patches
    {
      :p0 => DATA,
      :p1 => 'http://iij.dl.sourceforge.jp/jnethack/30862/jnethack-3.4.3-0.10.diff.gz'
    }
  end

  def install
    fails_with_llvm
    # Build everything in-order; no multi builds.
    ENV.deparallelize

    # Replace tokens introduced by the patches
    %w(
      sys/unix/Makefile.doc
      sys/unix/Makefile.src
      sys/unix/Makefile.top
      sys/unix/Makefile.utl
      sys/unix/nethack.sh
    ).each do |f|
      inreplace f, "__PREFIX__", prefix
      inreplace f, "__CFLAGS__", "-Wno-format -Wno-int-to-pointer-cast -Wno-pointer-to-int-cast"
      inreplace f, "__LDFLAGS__", ""
    end

    # Symlink makefiles
    system 'sh sys/unix/setup.sh'

    inreplace "include/config.h",
      /^#\s*define HACKDIR.*$/,
      "#define HACKDIR \"#{libexec}\""

    # Make the data first, before we munge the CFLAGS
    system "cd dat;make"

    Dir.chdir 'dat' do
      %w(perm logfile).each do |f|
        system "touch", f
        libexec.install f
      end

      # Stage the data
      libexec.install %w(jhelp jhh jcmdhelp jhistory jopthelp jwizhelp dungeon license data jdata.base joracles options jrumors.tru jrumors.fal quest.dat jquest.txt)
      libexec.install Dir['*.lev']
    end

    # Make the game
    ENV.append_to_cflags "-I../include"
    system 'cd src;make'

    bin.install 'src/jnethack'
    (libexec+'save').mkpath
  end
end

__END__
--- src/options.c.orig	2006-08-12 16:45:15.000000000 +0900
+++ src/options.c	2006-08-12 16:45:43.000000000 +0900
@@ -137,7 +137,7 @@
 #else
 	{"news", (boolean *)0, FALSE, SET_IN_FILE},
 #endif
-	{"null", &flags.null, TRUE, SET_IN_GAME},
+	{"null", &flags.null, FALSE, SET_IN_GAME},
 #ifdef MAC
 	{"page_wait", &flags.page_wait, TRUE, SET_IN_GAME},
 #else
--- sys/unix/Makefile.doc.orig	2006-07-29 05:14:04.000000000 +0900
+++ sys/unix/Makefile.doc	2006-07-29 05:24:47.000000000 +0900
@@ -40,8 +40,8 @@
 	latex Guidebook.tex
 
 
-GAME	= nethack
-MANDIR	= /usr/local/man/man6
+GAME	= jnethack
+MANDIR	= $(DESTDIR)__PREFIX__/share/man/man6
 MANEXT	= 6
 
 # manual installation for most BSD-style systems
--- sys/unix/Makefile.src.orig	2008-05-12 09:35:18.000000000 +0900
+++ sys/unix/Makefile.src	2008-05-12 09:36:38.000000000 +0900
@@ -36,7 +36,7 @@
 # SHELL=E:/GEMINI2/MUPFEL.TTP
 
 # Normally, the C compiler driver is used for linking:
-LINK=$(CC)
+LINK=$(CC) __CFLAGS__
 
 # Pick the SYSSRC and SYSOBJ lines corresponding to your desired operating
 # system.
@@ -72,7 +72,7 @@
 #
 #	If you are using GCC 2.2.2 or higher on a DPX/2, just use:
 #
-CC = gcc
+#CC = gcc
 #
 #	For HP/UX 10.20 with GCC:
 # CC = gcc -D_POSIX_SOURCE
@@ -154,8 +154,8 @@
 # flags for debugging:
 # CFLAGS = -g -I../include
 
-CFLAGS = -W -g -O -I../include
-LFLAGS = 
+CFLAGS = __CFLAGS__ -I../include
+LFLAGS = __LDFLAGS__
 
 # The Qt and Be window systems are written in C++, while the rest of
 # NetHack is standard C.  If using Qt, uncomment the LINK line here to get
--- sys/unix/Makefile.top.orig	2006-08-11 13:30:01.000000000 +0900
+++ sys/unix/Makefile.top	2006-08-11 13:35:41.000000000 +0900
@@ -14,18 +14,18 @@
 # MAKE = make
 
 # make NetHack
-PREFIX	 = /usr
+PREFIX	 = $(DESTDIR)__PREFIX__
 GAME     = jnethack
 # GAME     = nethack.prg
 GAMEUID  = games
-GAMEGRP  = bin
+GAMEGRP  = games
 
 # Permissions - some places use setgid instead of setuid, for instance
 # See also the option "SECURE" in include/config.h
-GAMEPERM = 04755
-FILEPERM = 0644
+GAMEPERM = 02755
+FILEPERM = 0664
 EXEPERM  = 0755
-DIRPERM  = 0755
+DIRPERM  = 0775
 
 # GAMEDIR also appears in config.h as "HACKDIR".
 # VARDIR may also appear in unixconf.h as "VAR_PLAYGROUND" else GAMEDIR
@@ -35,9 +35,9 @@
 # therefore there should not be anything in GAMEDIR that you want to keep
 # (if there is, you'll have to do the installation by hand or modify the
 # instructions)
-GAMEDIR  = $(PREFIX)/games/lib/$(GAME)dir
+GAMEDIR  = $(PREFIX)/share/$(GAME)dir
 VARDIR  = $(GAMEDIR)
-SHELLDIR = $(PREFIX)/games
+SHELLDIR = $(PREFIX)/bin
 
 # per discussion in Install.X11 and Install.Qt
 VARDATND = 
--- sys/unix/Makefile.utl.orig	2008-05-12 10:17:59.000000000 +0900
+++ sys/unix/Makefile.utl	2008-05-12 10:19:33.000000000 +0900
@@ -15,7 +15,7 @@
 
 # if you are using gcc as your compiler,
 #	uncomment the CC definition below if it's not in your environment
-CC = gcc
+#CC = gcc
 #
 #	For Bull DPX/2 systems at B.O.S. 2.0 or higher use the following:
 #
@@ -89,8 +89,8 @@
 # flags for debugging:
 # CFLAGS = -g -I../include
 
-CFLAGS = -O -I../include
-LFLAGS =
+CFLAGS = __CFLAGS__ -I../include
+LFLAGS = __LDFLAGS__
 
 LIBS =
  
@@ -276,7 +276,7 @@
 #	dependencies for recover
 #
 recover: $(RECOVOBJS)
-	$(CC) $(LFLAGS) -o recover $(RECOVOBJS) $(LIBS)
+	$(CC) $(CFLAGS) $(LFLAGS) -o recover $(RECOVOBJS) $(LIBS)
 
 recover.o: recover.c $(CONFIG_H) ../include/date.h
 
--- sys/unix/nethack.sh.orig	2006-08-24 23:23:30.000000000 +0900
+++ sys/unix/nethack.sh	2006-08-24 23:24:35.000000000 +0900
@@ -5,6 +5,7 @@
 export HACKDIR
 HACK=$HACKDIR/nethack
 MAXNROFPLAYERS=20
+COCOT="__PREFIX__/bin/cocot -t UTF-8 -p EUC-JP"
 
 # JP
 # set LC_ALL, NETHACKOPTIONS etc..
@@ -26,6 +27,10 @@
 	export USERFILESEARCHPATH
 fi
 
+if [ "X$LANG" = "Xja_JP.eucJP" ] ; then
+	COCOT=""
+fi
+
 #if [ "X$DISPLAY" ] ; then
 #	xset fp+ $HACKDIR
 #fi
@@ -84,9 +89,9 @@
 cd $HACKDIR
 case $1 in
 	-s*)
-		exec $HACK "$@"
+		exec $COCOT $HACK "$@"
 		;;
 	*)
-		exec $HACK "$@" $MAXNROFPLAYERS
+		exec $COCOT $HACK "$@" $MAXNROFPLAYERS
 		;;
 esac
--- win/tty/termcap.c.orig	2006-08-09 19:55:36.000000000 +0900
+++ win/tty/termcap.c	2006-08-09 20:05:44.000000000 +0900
@@ -861,7 +861,7 @@
 
 #include <curses.h>
 
-#ifndef LINUX
+#if !defined(LINUX) && !defined(__APPLE__)
 extern char *tparm();
 #endif
 
