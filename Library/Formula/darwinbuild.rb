require 'formula'

class Darwinbuild < Formula
  homepage 'http://darwinbuild.macosforge.org/'
  head 'http://svn.macosforge.org/repository/darwinbuild/trunk/'

  def patches
    DATA
  end

  def install
    ENV.delete('CC')
    ENV.delete('LD')
    system "xcodebuild", "-configuration", "Release", "install", "DSTROOT=/", "PREFIX=#{prefix}", "SYMROOT=build"
  end
end

__END__
diff --git a/common.mk b/common.mk
index 424109b..56fad54 100644
--- a/common.mk
+++ b/common.mk
@@ -15,9 +15,9 @@ BINDIR=$(DESTDIR)$(PREFIX)/bin
 DATDIR=$(DESTDIR)$(PREFIX)/share
 INCDIR=$(DESTDIR)$(PREFIX)/include
 INSTALL=install
-INSTALL_EXE_FLAGS=-m 0755 -o root -g wheel
+INSTALL_EXE_FLAGS=-m 0755
 INSTALL_DIR_FLAGS=$(INSTALL_EXE_FLAGS)
-INSTALL_DOC_FLAGS=-m 0644 -o root -g wheel
+INSTALL_DOC_FLAGS=-m 0644
 
 SED=/usr/bin/sed
 

