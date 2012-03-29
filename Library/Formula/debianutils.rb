require 'formula'

# This formula will install run-parts(8), ischroot(1) and tempfile(1)

class Debianutils < Formula
  homepage 'http://anonscm.debian.org/gitweb/?p=users/clint/debianutils.git'
  version '4.3'
  url "http://anonscm.debian.org/gitweb/?p=users/clint/debianutils.git;a=snapshot;h=debian/4.3;sf=tgz"
  md5 '57a32588c7aae0a193aebddf29bb06a4'

  # some commands are Debian Linux specific and we don't want them. 
  def patches; DATA; end

  def install
    system "aclocal"
    system "automake --gnu --add-missing"
    system "autoconf"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
    "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/run-parts --version"
    system "#{bin}/ischroot --version"
    system "#{bin}/tempfile --version"
  end
end
__END__
--- a/Makefile.am	2012-03-29 17:58:01.000000000 +0200
+++ b/Makefile.am	2012-03-29 17:56:42.000000000 +0200
@@ -1,17 +1,9 @@
 AUTOMAKE_OPTIONS = foreign
 
-SUBDIRS = po4a
-
 bin_PROGRAMS = run-parts tempfile ischroot
 run_parts_SOURCES = run-parts.c
 tempfile_SOURCES = tempfile.c
 ischroot_SOURCES = ischroot.c
 
-bin_SCRIPTS = which savelog
-
-sbin_SCRIPTS = installkernel add-shell remove-shell
-
 man_MANS = run-parts.8 \
-	   installkernel.8 savelog.8 \
-	   tempfile.1 which.1 add-shell.8 \
-	   remove-shell.8 ischroot.1
+	   tempfile.1 ischroot.1
