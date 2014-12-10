require 'formula'

class Babeld < Formula
  homepage 'http://www.pps.univ-paris-diderot.fr/~jch/software/babel/'
  url 'http://www.pps.univ-paris-diderot.fr/~jch/software/files/babeld-1.4.2.tar.gz'
  sha1 '53c02193e191fa3ab6ac5c4df9cde9795d4fb8b0'

  patch :DATA

  def install
    system "make", "LDLIBS=''"
    system "make", "install", "PREFIX=#{prefix}"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 7ad8b78..39c415c 100644
--- a/Makefile
+++ b/Makefile
@@ -38,12 +38,12 @@ install.minimal: babeld
 	cp -f babeld $(TARGET)$(PREFIX)/bin
 
 install: install.minimal all
-	mkdir -p $(TARGET)$(PREFIX)/man/man8
-	cp -f babeld.man $(TARGET)$(PREFIX)/man/man8/babeld.8
+	mkdir -p $(TARGET)$(PREFIX)/share/man/man8
+	cp -f babeld.man $(TARGET)$(PREFIX)/share/man/man8/babeld.8
 
 uninstall:
 	-rm -f $(TARGET)$(PREFIX)/bin/babeld
-	-rm -f $(TARGET)$(PREFIX)/man/man8/babeld.8
+	-rm -f $(TARGET)$(PREFIX)/share/man/man8/babeld.8
 
 clean:
 	-rm -f babeld babeld.html *.o *~ core TAGS gmon.out

