# encoding: UTF-8

require 'formula'

class Unac < Formula
  homepage 'http://savannah.nongnu.org/projects/unac'
  url 'http://ftp.de.debian.org/debian/pool/main/u/unac/unac_1.8.0.orig.tar.gz'
  sha1 '3e779bb7f3b505880ac4f43b48ee2f935ef8aa36'

  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  depends_on 'gettext' => :build

  patch :DATA

  patch :p0 do
    url "http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=5;filename=patch-libunac1.txt;att=1;bug=623340"
    sha1 "5b273127609b98092b8f3bb1b4c3e9f137968151"
  end

  patch :p0 do
    url "http://bugs.debian.org/cgi-bin/bugreport.cgi?msg=10;filename=patch-unaccent.c.txt;att=1;bug=623340"
    sha1 "689a1f32cdf08e3dab04bef1605666e4288ae64e"
  end

  patch do
    url "http://ftp.de.debian.org/debian/pool/main/u/unac/unac_1.8.0-6.diff.gz"
    sha1 "ed44c7dd2a093a970be51f19dfd1da396b08797e"
  end

  def install
    chmod 0755, "configure"
    touch "config.rpath"
    inreplace "autogen.sh", "libtool", "glibtool"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Separate steps to prevent race condition in folder creation
    system "make"
    ENV.j1
    system "make install"
  end

  test do
    assert_equal "foo", shell_output("#{bin}/unaccent utf-8 fóó").strip
  end
end

# configure.ac doesn't properly detect Mac OS's iconv library. This patch fixes that.
__END__
diff --git a/configure.ac b/configure.ac
index 4a4eab6..9f25d50 100644
--- a/configure.ac
+++ b/configure.ac
@@ -49,6 +49,7 @@ AM_MAINTAINER_MODE

 AM_ICONV

+LIBS="$LIBS -liconv"
 AC_CHECK_FUNCS(iconv_open,,AC_MSG_ERROR([
 iconv_open not found try to install replacement from
 http://www.gnu.org/software/libiconv/
