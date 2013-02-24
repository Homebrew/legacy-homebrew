require 'formula'

class Libdnet < Formula
  homepage 'http://code.google.com/p/libdnet/'
  url 'http://libdnet.googlecode.com/files/libdnet-1.12.tgz'
  sha1 '71302be302e84fc19b559e811951b5d600d976f8'

  depends_on :automake
  depends_on :libtool

  option 'with-python', 'Build Python module'

  # Fix use of deprecated macros
  # http://code.google.com/p/libdnet/issues/detail?id=27
  def patches
    DATA
  end

  def install
    # autoreconf to get '.dylib' extension on shared lib
    ENV['ACLOCAL'] = 'aclocal -I config'
    system 'autoreconf', '-ivf'

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --mandir=#{man}
    ]
    args << "--with-python" if build.include? "with-python"
    system "./configure", *args
    system "make install"
  end
end


__END__
diff --git a/configure.in b/configure.in
index 72ac63c..109dc63 100644
--- a/configure.in
+++ b/configure.in
@@ -10,7 +10,7 @@ AC_CONFIG_AUX_DIR(config)
 AC_SUBST(ac_aux_dir)
 
 AM_INIT_AUTOMAKE(libdnet, 1.12)
-AM_CONFIG_HEADER(include/config.h)
+AC_CONFIG_HEADERS(include/config.h)
 
 dnl XXX - stop the insanity!@#$
 AM_MAINTAINER_MODE
