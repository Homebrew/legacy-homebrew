require 'formula'

class Wcd < Formula
  homepage 'http://wcd.sourceforge.net/'
  url 'http://waterlan.home.xs4all.nl/wcd-5.2.3-src.tar.gz'
  sha1 '570160c7cfa3bf5c6d2d0cfb3bcbc789d983016c'

  def patches
    DATA
  end

  depends_on 'gettext'

  def install
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    system "wcd.exe"
  end

  def caveats; <<-EOS
    You could follow these steps to use wcd:
    1. Create bin directory in your home directory.
    $ mkdir ~/bin
    2. Copy and paste the following 6 lines in your profile
    such as ~/.profile or ~/.bash_profile
    export WCDHOME=\$HOME
    function wcd
    {
      /usr/local/bin/wcd.exe "$@"
      . ${WCDHOME:-${HOME}}/bin/wcd.go
    }
    3. Open a new terminal and run wcd to scan your disk
    $ wcd -s
    4. Use wcd to jump to any directory in your home by typing
    first several characters.
    $ wcd Doc

    See the manual page of wcd for detail.
    $ man wcd
    EOS
  end
end

__END__
diff -rupN wcd-5.2.3/src/Makefile ../wcd-5.2.3/src/Makefile
--- wcd-5.2.3/src/Makefile	2012-10-09 05:24:07.000000000 -0800
+++ ../wcd-5.2.3/src/Makefile	2013-08-22 14:14:22.000000000 -0800
@@ -336,7 +336,8 @@ endif
 # dynamically) comment the LDFLAGS line and add the 'libncurses.a' file
 # (often found as /usr/lib/libncurses.a) to the OBJS1 list.
 
-CFLAGS_USER	=
+
+CFLAGS_USER	=-I/usr/local/opt/gettext/include 
 CFLAGS	= -O2 -Wall -Wextra -Wno-unused-parameter -Wconversion $(RPM_OPT_FLAGS) $(CPPFLAGS) $(CFLAGS_USER)
 
 EXTRA_CFLAGS	= -Ic3po \
@@ -364,7 +365,7 @@ ifdef ASCII_TREE
 	EXTRA_CFLAGS += -DASCII_TREE
 endif
 
-LDFLAGS_USER   =
+LDFLAGS_USER   = -L/usr/local/opt/gettext/lib -lintl -lncurses
 LDFLAGS		= $(RPM_OPT_FLAGS) \
 	          $(LIB_CURSES) \
 	          $(LIB_UNISTRING) \
@@ -572,7 +573,7 @@ install-bin: $(BIN)
 	$(MKDIR) -p -m 755 $(DESTDIR)$(bindir)
 	$(INSTALL_BIN) $(INSTALL_OBJS_BIN) $(DESTDIR)$(bindir)
 
-install: $(INSTALL_TARGETS)
+install: install-bin install-man
 
 uninstall:
 	@echo "-- target: uninstall"
diff -rupN wcd-5.2.3/src/wcd.c ../wcd-5.2.3/src/wcd.c
--- wcd-5.2.3/src/wcd.c	2012-10-29 12:10:25.000000000 -0800
+++ ../wcd-5.2.3/src/wcd.c	2013-08-20 19:14:27.000000000 -0800
@@ -41,7 +41,7 @@ Jason Mathews' file filelist.c was a sta
 #include <string.h>
 #include <ctype.h>
 #include <time.h>
-#include <malloc.h>
+// #include <malloc.h>
 #if !defined(__TURBOC__) && !defined(_MSC_VER)
 # include <unistd.h>
 #endif

