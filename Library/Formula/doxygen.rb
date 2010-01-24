require 'formula'

class Doxygen <Formula
  url 'http://ftp.stack.nl/pub/users/dimitri/doxygen-1.6.1.src.tar.gz'
  homepage 'http://www.doxygen.org/'
  md5 '2ec343643e134f0d3ce2069420bcb4f0'

  def patches
    DATA
  end
  
  def install
    inreplace 'Makefile.in', 'MAN1DIR = man/man1', 'MAN1DIR = share/man/man1'
    system "./configure", "--prefix", "#{prefix}"
    system "make"
    system "make", "install"
  end
end


__END__
diff -Naur doxygen-1.6.1/qtools/qglobal.h doxygen-1.6.1-working/qtools/qglobal.h 
--- doxygen-1.6.1/qtools/qglobal.h	2008-12-06 13:16:20.000000000 +0000
+++ doxygen-1.6.1-working/qtools/qglobal.h	2009-11-11 20:58:40.000000000 +0000
@@ -86,7 +86,10 @@
 #  if !defined(MAC_OS_X_VERSION_10_5)
 #       define MAC_OS_X_VERSION_10_5 MAC_OS_X_VERSION_10_4 + 1
 #  endif
-#  if (MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_5)
+#  if !defined(MAC_OS_X_VERSION_10_6)
+#       define MAC_OS_X_VERSION_10_6 MAC_OS_X_VERSION_10_5 + 1
+#  endif
+#  if (MAC_OS_X_VERSION_MAX_ALLOWED > MAC_OS_X_VERSION_10_6)
 #    error "This version of Mac OS X is unsupported"
 #  endif
 #elif defined(MSDOS) || defined(_MSDOS) || defined(__MSDOS__)
