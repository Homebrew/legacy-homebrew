require 'formula'

class Gource < Formula
  homepage 'http://code.google.com/p/gource/'
  url 'http://gource.googlecode.com/files/gource-0.39.tar.gz'
  sha1 '1dd6476e56a197354ce93612c7be9aff8c1f8cd2'

  head 'https://github.com/acaudwell/Gource.git'

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  depends_on :x11 if MacOS::X11.installed?
  depends_on :freetype

  depends_on 'pkg-config' => :build
  depends_on 'glm' => :build

  depends_on 'boost'
  depends_on 'glew'
  depends_on 'jpeg'
  depends_on 'pcre'
  depends_on 'sdl'
  depends_on 'sdl_image'

  # configure fails to find boost libs on OS X;
  # merged upstream, should be in the next release
  # https://github.com/acaudwell/Gource/pull/17
  def patches; DATA; end unless build.head?

  def install
    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    system "autoreconf -f -i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--without-x",
                          "--disable-freetypetest"
    system "make install"
  end

  def test
    cd HOMEBREW_REPOSITORY do
      system "#{bin}/gource"
    end
  end
end

__END__
diff --git a/configure b/configure
index f3f6384..97361de 100755
--- a/configure
+++ b/configure
@@ -7198,7 +7198,7 @@ $as_echo "#define HAVE_BOOST_SYSTEM /**/" >>confdefs.h
 
      LDFLAGS_SAVE=$LDFLAGS
             if test "x$ax_boost_user_system_lib" = "x"; then
-                for libextension in `ls $BOOSTLIBDIR/libboost_system*.a* $BOOSTLIBDIR/libboost_system*.so* 2>/dev/null | sed 's,.*/,,' | sed -e 's;^lib\(boost_system.*\)\.\(so\|a\).*$;\1;' | tac` ; do
+                for libextension in `ls -r $BOOSTLIBDIR/libboost_system* 2>/dev/null | sed 's,.*/lib,,' | sed 's,\..*,,'` ; do
                      ax_lib=${libextension}
            as_ac_Lib=`$as_echo "ac_cv_lib_$ax_lib''_exit" | $as_tr_sh`
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for exit in -l$ax_lib" >&5
@@ -7246,7 +7246,7 @@ fi
 
        done
                 if test "x$link_system" != "xyes"; then
-                for libextension in `ls $BOOSTLIBDIR/boost_system*.{dll,a}* 2>/dev/null | sed 's,.*/,,' | sed -e 's;^\(boost_system.*\)\.\(dll\|a\).*$;\1;' | tac` ; do
+                for libextension in `ls -r $BOOSTLIBDIR/boost_system* 2>/dev/null | sed 's,.*/,,' | sed -e 's,\..*,,'` ; do
                      ax_lib=${libextension}
            as_ac_Lib=`$as_echo "ac_cv_lib_$ax_lib''_exit" | $as_tr_sh`
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for exit in -l$ax_lib" >&5
@@ -7437,7 +7437,7 @@ $as_echo "#define HAVE_BOOST_FILESYSTEM /**/" >>confdefs.h
 
             BOOSTLIBDIR=`echo $BOOST_LDFLAGS | sed -e 's/[^\/]*//'`
             if test "x$ax_boost_user_filesystem_lib" = "x"; then
-                for libextension in `ls $BOOSTLIBDIR/libboost_filesystem*.so* $BOOSTLIBDIR/libboost_filesystem*.dylib* $BOOSTLIBDIR/libboost_filesystem*.a* 2>/dev/null | sed 's,.*/,,' | sed -e 's;^lib\(boost_filesystem.*\)\.\(dylib\|a\|so\).*$;\1;' | tac` ; do
+                for libextension in `ls -r $BOOSTLIBDIR/libboost_filesystem* 2>/dev/null | sed 's,.*/lib,,' | sed 's,\..*,,'` ; do
                      ax_lib=${libextension}
            as_ac_Lib=`$as_echo "ac_cv_lib_$ax_lib''_exit" | $as_tr_sh`
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for exit in -l$ax_lib" >&5
@@ -7485,7 +7485,7 @@ fi
 
        done
                 if test "x$link_filesystem" != "xyes"; then
-                for libextension in `ls $BOOSTLIBDIR/boost_filesystem*.dll* $BOOSTLIBDIR/boost_filesystem*.a* 2>/dev/null | sed 's,.*/,,' | sed -e 's;^\(boost_filesystem.*\)\.\(dll\|a\).*$;\1;' | tac` ; do
+                for libextension in `ls -r $BOOSTLIBDIR/boost_filesystem* 2>/dev/null | sed 's,.*/,,' | sed -e 's,\..*,,'` ; do
                      ax_lib=${libextension}
            as_ac_Lib=`$as_echo "ac_cv_lib_$ax_lib''_exit" | $as_tr_sh`
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking for exit in -l$ax_lib" >&5
