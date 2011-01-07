require 'formula'

class Logrotate <Formula
  url 'https://fedorahosted.org/releases/l/o/logrotate/logrotate-3.7.8.tar.gz'
  homepage 'http://packages.debian.org/testing/admin/logrotate'
  md5 'b3589bea6d8d5afc8a84134fddaae973'

  depends_on 'popt'

  def patches
    # these patches emerge from the logrotate patch. Recursively nice!
    debian_patches=['configparse.patch',
                    'datehack.patch',
                    'compressutime.patch',
                    'man-startcount.patch',
                    'dst.patch',
                    'dateext-504079.patch',
                    'rh-toolarge.patch',
                    'rh-curdir2.patch',
                    'copyloginfo-512152.patch',
                    'sharedscripts-519432.patch',
                    'chown-484762.patch',
                    'create-388608.patch',
                    'nofollow.patch',
                    'security-388608.patch'].collect {|p| "debian/patches/#{p}"}

    [
      DATA,
      "https://www.securehost.com/mirror/debian/pool/main/l/logrotate/logrotate_3.7.8-4.diff.gz",
      *debian_patches
    ]
  end

  def install
    system "make"
    system "make", "install", "BASEDIR=#{prefix}"
  end
end


__END__
diff --git a/config.c b/config.c
index 4e650f1..be7905a 100644
--- a/config.c
+++ b/config.c
@@ -12,6 +12,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/stat.h>
+#include <sys/syslimits.h>
 #include <time.h>
 #include <unistd.h>
 #include <assert.h>
diff --git a/logrotate.c b/logrotate.c
index 6427465..f0614a8 100644
--- a/logrotate.c
+++ b/logrotate.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
+#include <sys/syslimits.h>
 #include <time.h>
 #include <unistd.h>
 #include <glob.h>
diff --git a/Makefile b/Makefile
index f110ab5..49e55f4 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = $(shell awk '/Version:/ { print $$2 }' logrotate.spec)
 OS_NAME = $(shell uname -s)
 LFS = $(shell echo `getconf LFS_CFLAGS 2>/dev/null`)
-CFLAGS = -Wall -D_GNU_SOURCE -D$(OS_NAME) -DVERSION=\"$(VERSION)\" $(RPM_OPT_FLAGS) $(LFS)
+CFLAGS += -D_GNU_SOURCE -D$(OS_NAME) -DVERSION=\"$(VERSION)\" $(RPM_OPT_FLAGS) $(LFS)
 PROG = logrotate
 MAN = logrotate.8
 LOADLIBES = -lpopt
@@ -45,6 +45,15 @@ ifeq ($(OS_NAME),SunOS)
     endif
 endif
 
+# Darwin
+ifeq ($(OS_NAME),Darwin)
+    INSTALL = install
+    CC = gcc
+    ifeq ($(BASEDIR),)
+        BASEDIR = /usr/local
+    endif
+endif
+
 # Red Hat Linux
 ifeq ($(OS_NAME),Linux)
     INSTALL = install
@@ -52,8 +61,8 @@ ifeq ($(OS_NAME),Linux)
 endif
 
 ifneq ($(POPT_DIR),)
-    CFLAGS += -I$(POPT_DIR)
-    LOADLIBES += -L$(POPT_DIR)
+    CFLAGS += -I$(POPT_DIR)/include
+    LOADLIBES += -L$(POPT_DIR)/lib
 endif
 
 ifneq ($(STATEFILE),)
@@ -61,7 +70,7 @@ ifneq ($(STATEFILE),)
 endif
 
 BINDIR = $(BASEDIR)/sbin
-MANDIR = $(BASEDIR)/man
+MANDIR = $(BASEDIR)/share/man
 
 #--------------------------------------------------------------------------
 
@@ -70,7 +79,7 @@ SOURCES = $(subst .o,.c,$(OBJS) $(LIBOBJS))
 
 ifeq ($(RPM_OPT_FLAGS),)
 CFLAGS += -g
-LDFLAGS = -g
+LDFLAGS += -g
 endif
 
 ifeq (.depend,$(wildcard .depend))
@@ -89,7 +98,7 @@ clean:
 	rm -f $(OBJS) $(PROG) core* .depend
 
 depend:
-	$(CPP) $(CFLAGS) -M $(SOURCES) > .depend
+	$(CPP) $(CPPFLAGS) $(CFLAGS) -M $(SOURCES) > .depend
 
 .PHONY : test
 test: $(TARGET)
diff --git a/config.c b/config.c
index 4e650f1..9e9dc1c 100644
--- a/config.c
+++ b/config.c
@@ -93,7 +93,7 @@ static char *readPath(const char *configFile, int lineNum, char *key,

	chptr = start;

-	while( (len = mbrtowc(&pwc, chptr, strlen(chptr), NULL)) != 0 ) {
+	while( (len = strlen(chptr)) != 0 && (len = mbrtowc(&pwc, chptr, len, NULL)) != 0 ) {
		if( len == (size_t)(-1) || len == (size_t)(-2) || !iswprint(pwc) || iswblank(pwc) ) {
		    message(MESS_ERROR, "%s:%d bad %s path %s\n",
			    configFile, lineNum, key, start);
/usr/local/src/logrotate-3.7.8
