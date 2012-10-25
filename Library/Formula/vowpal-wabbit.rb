require 'formula'

class VowpalWabbit < Formula
  homepage 'https://github.com/JohnLangford/vowpal_wabbit'
  url 'https://github.com/JohnLangford/vowpal_wabbit/tarball/v7.0'
  sha1 '1960f9b8423ce13d6c0f29e3c23feeb2d52f2918'

  depends_on 'libtool' => :build
  depends_on 'automake' => :build

  def patches
    # Update autogen.sh to use glibtoolize from libtool.
    DATA
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

__END__
diff --git a/autogen.sh b/autogen.sh
index 41da9d8..92d4839 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,2 +1,2 @@
 #! /bin/sh
-libtoolize -f -c && aclocal -I ./acinclude.d -I /usr/share/aclocal && autoheader && automake -ac -Woverride && autoconf && ./configure "$@"
+/usr/local/bin/glibtoolize -f -c && aclocal -I ./acinclude.d -I /usr/share/aclocal && autoheader && automake -ac -Woverride && autoconf && ./configure "$@"
