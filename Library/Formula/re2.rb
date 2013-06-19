require 'formula'

class Re2 < Formula
  homepage 'https://code.google.com/p/re2/'
  url 'https://re2.googlecode.com/files/re2-20130115.tgz'
  sha1 '71f1eac7fb83393faedc966fb9cdb5ba1057d85f'

  def patches
    # fixes installation prefix to `CMAKE_PREFIX_PATH` in makefile
    DATA
  end

  def install
    system "make"
    system "make", "install"
  end

end

__END__
diff --git a/makefile b/makefile
index 4ded8ec..1bad3fc 100644
--- a/makefile
+++ b/makefile
@@ -20,7 +20,7 @@ NMFLAGS=-p
 
 # Variables mandated by GNU, the arbiter of all good taste on the internet.
 # http://www.gnu.org/prep/standards/standards.html
-prefix=/usr/local
+prefix=$CMAKE_PREFIX_PATH
 exec_prefix=$(prefix)
 bindir=$(exec_prefix)/bin
 includedir=$(prefix)/include
