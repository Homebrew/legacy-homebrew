require 'formula'

class Beecrypt < Formula
  homepage 'http://beecrypt.sourceforge.net'
  url 'http://sourceforge.net/projects/beecrypt/files/beecrypt/4.2.1/beecrypt-4.2.1.tar.gz'
  sha256 '286f1f56080d1a6b1d024003a5fa2158f4ff82cae0c6829d3c476a4b5898c55d'

  depends_on "icu4c"

  def patches
    # fix build with newer clang, gcc 4.7 (https://bugs.gentoo.org/show_bug.cgi?id=413951)
    { :p0 => DATA }
  end

  def install
    ENV.remove_from_cflags /-march=\S*/
    system "./configure", "--prefix=#{prefix}", "--disable-openmp", "--without-java", "--without-python"
    system "make"
    system "make check"
    system "make install"
  end
end

__END__
--- include/beecrypt/c++/util/AbstractSet.h~	2009-06-17 13:05:55.000000000 +0200
+++ include/beecrypt/c++/util/AbstractSet.h	2012-06-03 17:45:55.229399461 +0200
@@ -56,7 +56,7 @@
 					if (c->size() != size())
 						return false;
 
-					return containsAll(*c);
+					return this->containsAll(*c);
 				}
 				return false;
 			}
