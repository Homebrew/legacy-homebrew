class Babeld < Formula
  homepage "http://www.pps.univ-paris-diderot.fr/~jch/software/babel/"
  url "http://www.pps.univ-paris-diderot.fr/~jch/software/files/babeld-1.5.1.tar.gz"
  sha1 "6ff3a7685e62034df83b143a36a4960b2e4d89b9"
  head "https://github.com/jech/babeld.git"

  bottle do
    cellar :any
    sha1 "a965f70b84f8fea7ce7a7f92252e61d01a6b9e7b" => :yosemite
    sha1 "22262a12d06cf83d35f351a49d6af7e40e7f554d" => :mavericks
    sha1 "69e5c32092ccfdaeaff3615fbbaf15e41e327e41" => :mountain_lion
  end

  # https://lists.alioth.debian.org/pipermail/babel-users/2015-January/001826.html
  patch :DATA

  def install
    system "make", "LDLIBS=''"
    system "make", "install", "PREFIX=#{prefix}"
  end

  def caveats; <<-EOS.undent
    Due to changing network interfaces, this tool
    requires the usage of `sudo` at runtime.
    EOS
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

