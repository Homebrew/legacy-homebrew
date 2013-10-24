require 'formula'

class Bup < Formula
  homepage 'https://github.com/bup/bup'
  url 'https://github.com/bup/bup/archive/bup-0.25-rc1.tar.gz'
  sha1 '62e34c8cca17794ba27b56799ecc99c269dad6d9'

  head 'https://github.com/bup/bup.git', :branch => 'master'

  option "run-tests", "Run unit tests after compilation"

  depends_on :python

  # patch to make the `--prefix` parameter work
  # found at https://github.com/apenwarr/bup/pull/5
  def patches
    DATA
  end

  def install
    python do
      system "./configure", "--prefix=#{prefix}"
      system "make"
    end
    system "make test" if build.include? "run-tests"
    system "make install"
  end
end


__END__
diff --git a/Makefile b/Makefile
index ce91ff0..ecb0604 100644
--- a/Makefile
+++ b/Makefile
@@ -1,3 +1,4 @@
+-include config/config.vars
 OS:=$(shell uname | sed 's/[-_].*//')
 CFLAGS:=-Wall -O2 -Werror $(PYINCLUDE)
 SOEXT:=.so
@@ -14,9 +15,6 @@ bup: lib/bup/_version.py lib/bup/_helpers$(SOEXT) cmds

 Documentation/all: bup

-INSTALL=install
-PYTHON=python
-PREFIX=/usr
 MANDIR=$(DESTDIR)$(PREFIX)/share/man
 DOCDIR=$(DESTDIR)$(PREFIX)/share/doc/bup
 BINDIR=$(DESTDIR)$(PREFIX)/bin
diff --git a/config/config.vars.in b/config/config.vars.in
index 7bc32ee..a45827c 100644
--- a/config/config.vars.in
+++ b/config/config.vars.in
@@ -1,2 +1,5 @@
 CONFIGURE_FILES=@CONFIGURE_FILES@
 GENERATED_FILES=@GENERATED_FILES@
+PREFIX=@prefix@
+INSTALL=@INSTALL@
+PYTHON=@PYTHON@
