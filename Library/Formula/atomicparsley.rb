require 'formula'

class Atomicparsley < Formula
  url 'https://bitbucket.org/wez/atomicparsley/get/0.9.4.tar.bz2'
  homepage 'http://bitbucket.org/wez/atomicparsley/overview/'
  md5 '2ce6f39cedc959f46b5515920c35d0d7'

  head 'https://bitbucket.org/wez/atomicparsley', :using => :hg

  if MacOS.xcode_version >= "4.3"
    # when and if the tarball provides configure, remove autogen.sh and these deps
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def patches
    DATA # Fixes compilation with newer automake versions
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-universal"
    system "make install"
  end
end

__END__
diff --git a/configure.ac b/configure.ac
index 24099c9..eedd3cf 100644
--- a/configure.ac
+++ b/configure.ac
@@ -62,6 +62,7 @@ if test "$GCC" = "yes" ; then
   CXXFLAGS="$CXXFLAGS -Wall"""
 fi
 AC_PROG_OBJC
+AC_PROG_OBJCXX
 AC_C_BIGENDIAN

 AC_HEADER_DIRENT
