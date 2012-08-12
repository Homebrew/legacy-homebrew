require 'formula'

class Ht < Formula
  url 'http://downloads.sourceforge.net/project/hte/ht-source/ht-2.0.20.tar.bz2'
  homepage 'http://hte.sf.net/'
  sha256 '4aa162f10a13e60859bef1f04c6529f967fdfd660ae421ee25eab1fbabcd1ed0'

  depends_on 'lzo'

  # Use ncurses instead of ncursesw
  def patches
    DATA
  end

  def install
    system "chmod +x ./install-sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-x11-textmode"
    system "make install"
  end
end

__END__
diff --git a/configure b/configure
index 0bef387..0e47404 100755
--- a/configure
+++ b/configure
@@ -5738,7 +5738,7 @@ if test "x$ac_cv_header_ncurses_h" = xyes; then :
 _ACEOF
 
 $as_echo "#define CURSES_HDR <ncurses.h>" >>confdefs.h
- CURSES_LIB=ncursesw
+ CURSES_LIB=ncurses
 fi
 
 done
