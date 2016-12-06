require 'formula'

class Libiscsi < Formula
  homepage 'https://github.com/sahlberg/libiscsi'
  url 'https://sites.google.com/site/libiscsitarballs/libiscsitarballs/libiscsi-1.9.0.tar.gz'
  sha1 'b3d079cbafab68fe39a8061c4ed5094353094e3b'
  head 'https://github.com/sahlberg/libiscsi.git'

  option 'with-noinst', 'Install the noinst binaries (e.g. iscsi-test-cu)'

  depends_on 'cunit' if build.with? 'noinst'
  depends_on 'popt'
  depends_on :automake
  depends_on :libtool

  # Fix version number being too large for clang's linker (fixed upstream)
  # Workaround Silent Rules complaint with automake 1.10 from XCode 3.2.6 on
  # 10.6
  # Fix typo in libiscsi.syms (fixed upstream)
  # Fix SOL_TCP not being defined on OSX (fixed upstream)
  def patches
    DATA
  end

  def install
    if build.with? 'noinst'
      # Install the noinst binaries
      inreplace 'Makefile.am', 'noinst_PROGRAMS +=', 'bin_PROGRAMS +='
    end

    # inline usage requires gnu89 semantics
    ENV.append 'CFLAGS', '-std=gnu89 -g -O2' if ENV.compiler == :clang

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

__END__
diff --git a/Makefile.am b/Makefile.am
index 1797ddf..1cf0732 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -34,8 +34,12 @@ lib_libiscsi_la_SOURCES = \
 	lib/logging.c
 
 SONAME=$(firstword $(subst ., ,$(VERSION)))
-SOREL=$(shell printf "%d%02d%02d" $(subst ., ,$(VERSION)))
-lib_libiscsi_la_LDFLAGS = \
+version_split = $(subst ., ,$(VERSION))
+SOMAJOR = $(firstword $(version_split))
+SOMINOR = $(word 2, $(version_split))
+SOREVISION = $(word 3, $(version_split))
+SOREL = $(shell echo $(SOMINOR) + $(SOREVISION) | bc)
+ lib_libiscsi_la_LDFLAGS = \
 	-version-info $(SONAME):$(SOREL):0 -bindir $(bindir) -no-undefined \
 	-export-symbols $(srcdir)/lib/libiscsi.syms
 
diff --git a/configure.ac b/configure.ac
index 7995d06..bbdabe9 100644
--- a/configure.ac
+++ b/configure.ac
@@ -3,8 +3,8 @@ AC_INIT(libiscsi, m4_esyscmd([grep 'Version:' ./packaging/RPM/libiscsi.spec.in 2
 AC_CONFIG_SRCDIR([lib/init.c])
 AC_CONFIG_MACRO_DIR([m4])
 
-AM_INIT_AUTOMAKE
-AM_SILENT_RULES
+AM_INIT_AUTOMAKE([foreign])
+m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES])
 LT_INIT
 
 AC_CANONICAL_HOST
diff --git a/lib/libiscsi.syms b/lib/libiscsi.syms
index 80673f5..35e06d1 100644
--- a/lib/libiscsi.syms
+++ b/lib/libiscsi.syms
@@ -87,7 +87,7 @@ iscsi_set_tcp_keepidle
 iscsi_set_tcp_keepcnt
 iscsi_set_tcp_keepintvl
 iscsi_set_tcp_syncnt
-iscsi_set_bind_interface
+iscsi_set_bind_interfaces
 iscsi_startstopunit_sync
 iscsi_startstopunit_task
 iscsi_synchronizecache10_sync
diff --git a/lib/socket.c b/lib/socket.c
index 54d6234..53c9581 100644
--- a/lib/socket.c
+++ b/lib/socket.c
@@ -103,7 +103,7 @@ int set_tcp_sockopt(int sockfd, int optname, int value)
 {
 	int level;
 
-	#if defined(__FreeBSD__) || defined(__sun)
+	#if defined(__FreeBSD__) || defined(__sun) || (defined(__APPLE__) && defined(__MACH__))
 	struct protoent *buf;
 
 	if ((buf = getprotobyname("tcp")) != NULL)
