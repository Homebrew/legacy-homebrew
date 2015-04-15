require 'formula'

class Djview4 < Formula
  homepage 'http://djvu.sourceforge.net/djview4.html'
  url 'https://downloads.sourceforge.net/project/djvu/DjView/4.10/djview-4.10.tar.gz'
  sha1 '7526d23aa501ce34468e42f094f49b6b96cce186'

  depends_on 'pkg-config' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'djvulibre'
  depends_on 'qt'

  # Patch build files for correct flag and dependency handling
  # Fixed in upstream commits f1c0fad and a66dc11
  patch :DATA

  def install
    # prevent autogen to call configure without flags
    ENV['NOCONFIGURE'] = '1'

    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--with-x=no",
                          "--disable-nsdejavu",
                          "--disable-desktopfiles"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"

    # From the djview4.8 README:
    # Note3: Do not use command "make install".
    # Simply copy the application bundle where you want it.
    prefix.install 'src/djview.app'
  end
end


__END__
--- djview-4.10-orig/src/Makefile.am	2015-02-10 04:50:29.000000000 +0300
+++ djview-4.10/src/Makefile.am	2015-04-12 23:01:55.000000000 +0300
@@ -12,7 +12,7 @@
 bin_SCRIPTS = djview
 
 djview: Makefile.qmake FORCE
-	${MAKE} -f Makefile.qmake djview
+	${MAKE} -f Makefile.qmake
 
 FORCE: 
 
--- djview-4.10-orig/configure.ac	2015-02-10 04:51:25.000000000 +0300
+++ djview-4.10/configure.ac	2015-04-13 00:42:16.000000000 +0300
@@ -256,7 +256,7 @@
     AC_SUBST(NSDEJAVU_LIBS)
 fi
 
-AM_CONDITIONAL([WANT_NSDEJAVU], [test "x${ac_nsdejavu}" != "no"])
+AM_CONDITIONAL([WANT_NSDEJAVU], [test "x${ac_nsdejavu}" != "xno"])
 
 
 # ----------------------------------------

