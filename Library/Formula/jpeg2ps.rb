require 'formula'

class Jpeg2ps < Formula
  homepage 'http://www.pdflib.com/download/free-software/jpeg2ps/'
  url 'http://www.pdflib.com/fileadmin/pdflib/products/more/jpeg2ps/jpeg2ps-1.9.tar.gz'
  sha1 '2fc2701c7c00ba17b051ebcc7b9c8059eb6614f9'

  def patches
    # fix Makefile to install to share/man instead of man
    DATA
  end

  def install
    system "make", "install"
  end

  test do
    system "wget https://upload.wikimedia.org/wikipedia/en/b/bd/Test.jpg"
    system "jpeg2ps Test.jpg > Test.eps"
    File.file?("Test.eps")
  end
end

__END__
diff --git a/Makefile b/Makefile
index 1586b82..817a173 100644
--- a/Makefile
+++ b/Makefile
@@ -45,7 +45,7 @@ DOSDISTFILES = $(DISTFILES) jpeg2ps.exe
 BINDIR = /usr/local/bin
 
 # Location where to install the manual page.
-MANDIR = /usr/local/man/man1
+MANDIR = /usr/local/share/man/man1
 
 CONVFILES = \
        jpeg2ps.c psimage.h readjpeg.c asc85ec.c getopt.c       \
