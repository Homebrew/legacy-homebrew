require 'formula'

class Cscope < Formula
  homepage 'http://cscope.sourceforge.net/'
  url 'http://sourceforge.net/projects/cscope/files/cscope/15.8a/cscope-15.8a.tar.gz'
  sha1 '00f76825791b895532778f720c509cd13b9d6846'

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
 #define	FIELDS		10
 
-#if (BSD || V9) && !__NetBSD__ && !__FreeBSD__
+#if (BSD || V9) && !__NetBSD__ && !__FreeBSD__ && !__MACH__
 # define TERMINFO	0	/* no terminfo curses */
 #else
 # define TERMINFO	1
-- 
1.6.4

