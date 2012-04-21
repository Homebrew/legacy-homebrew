require 'formula'

class Ttfautohint < Formula
  homepage 'http://www.freetype.org/ttfautohint'
  url 'http://download.savannah.gnu.org/releases/freetype/ttfautohint-0.8.tar.gz'
  md5 '36796a56eb0aa4bbf770435908f49e8c'

  def patches
    DATA
  end

  def install
    ENV.x11

    system "./configure", "--disable-dependency-tracking",
                          "--with-qt=no",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "ttfautohint -V"
  end
end

__END__
--- a/configure   2012-04-12 22:35:17.000000000 -0700
+++ b/configure   2012-04-12 22:35:24.000000000 -0700
@@ -23183,17 +23183,17 @@
   if test "$ft_config" = "no"; then
     as_fn_error $? "FreeType library is missing; see http://www.freetype.org/" "$LINENO" 5
   fi
 else
   ft_config="$freetype_config"
 fi
 
 FREETYPE_CPPFLAGS="`$ft_config --cflags`"
-FREETYPE_LIBS="`$ft_config --libtool`"
+FREETYPE_LIBS="`$ft_config --libs`"
 
 
 
 
 
 { $as_echo "$as_me:${as_lineno-$LINENO}: checking whether FreeType header files are version 2.4.5 or higher" >&5
 $as_echo_n "checking whether FreeType header files are version 2.4.5 or higher... " >&6; }
 old_CPPFLAGS="$CPPFLAGS"
