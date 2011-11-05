require 'formula'

class Cscope < Formula
  url 'http://downloads.sourceforge.net/sourceforge/cscope/cscope-15.7a.tar.bz2'
  homepage 'http://cscope.sourceforge.net/'
  md5 'da43987622ace8c36bbf14c15a350ec1'

  # Patch from http://bugs.gentoo.org/show_bug.cgi?ctype=html&id=111621
  def patches; DATA; end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

__END__
diff --git a/src/constants.h b/src/constants.h
index 7ad8005..844836e 100644
--- a/src/constants.h
+++ b/src/constants.h
@@ -103,7 +103,7 @@
 #define INCLUDES	8
 #define	FIELDS		9
 
-#if (BSD || V9) && !__NetBSD__ && !__FreeBSD__
+#if (BSD || V9) && !__NetBSD__ && !__FreeBSD__ && !__MACH__
 # define TERMINFO	0	/* no terminfo curses */
 #else
 # define TERMINFO	1
-- 
1.6.4

