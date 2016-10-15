require 'formula'

class Pfstools < Formula
  homepage 'http://pfstools.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/pfstools/pfstools/1.8.5/pfstools-1.8.5.tar.gz'
  sha1 'dc595438f0fd8b40a05d9f9c498892363a1b3f05'


  depends_on :automake
  depends_on :autoconf

  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
  depends_on :x11
  depends_on 'libtiff'
  depends_on 'netpbm'
  depends_on 'openexr'
  depends_on 'imagemagick'
  depends_on 'qt'
  depends_on 'libpng'
  depends_on 'little-cms'

  def patches
    # This patch removes the creation of an app for pfsview in /Applications/.
    DATA
  end

  def install
    system "aclocal"
    system "automake", "--add-missing"
    system "./configure",
    "CPATH=#{Formula.factory('netpbm').opt_prefix}/include", "--with-moc=#{Formula.factory('qt').prefix}/bin/moc", "CXXFLAGS=-m64", "--prefix=#{prefix}", "--mandir=#{man}" "CXXFLAGS=-m64", "--prefix=#{prefix}", "--mandir=#{man}"

    system "make"
    system "make", "install"
  end
end

__END__

diff --git a/src/pfsview/Makefile.am b/src/pfsview/Makefile.am
index 47d5b27..b68fdcb 100644
--- a/src/pfsview/Makefile.am
+++ b/src/pfsview/Makefile.am
@@ -32,13 +32,3 @@ CLEANFILES = $(BUILT_SOURCES)
 resources.cpp: pfsview.qrc
 	rcc -o $@ $<

-if MAC_OS
-install-data-hook:
-	install -d "/Applications/pfsview.app/Contents"
-	install -d "/Applications/pfsview.app/Contents/MacOS"
-	install -d "/Applications/pfsview.app/Contents/Resources"
-	install "mac_os/PkgInfo" "/Applications/pfsview.app/Contents"
-	install "mac_os/Info.plist" "/Applications/pfsview.app/Contents"
-	install "mac_os/pfsview_icon_mac.icns" "/Applications/pfsview.app/Contents/Resources"
-	mv $(DESTDIR)$(bindir)/pfsview /Applications/pfsview.app/Contents/MacOS/
-endif
