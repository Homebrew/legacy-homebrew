require 'formula'

class Sslscan < Formula
  homepage 'https://www.titania-security.com/labs/sslscan'
  url 'https://downloads.sourceforge.net/project/sslscan/sslscan/sslscan%201.8.0/sslscan-1.8.0.tgz'
  sha1 'c867d766b38401ea0c0cde597497188e456e6d71'

  # Remove hardcoded gcc in Makefile
  patch :DATA

  def install
    system "make"
    bin.install "sslscan"
    man1.install "sslscan.1"
  end

  test do
    system "#{bin}/sslscan"
  end
end

__END__
diff --git a/Makefile b/Makefile
index a3e1654..b1fbda8 100644
--- a/Makefile
+++ b/Makefile
@@ -3,7 +3,7 @@ BINPATH = /usr/bin/
 MANPATH = /usr/share/man/
 
 all:
-	gcc -lssl -o sslscan $(SRCS) $(LDFLAGS) $(CFLAGS)
+	$(CC) -lssl -lcrypto -o sslscan $(SRCS) $(LDFLAGS) $(CFLAGS)
 
 install:
 	cp sslscan $(BINPATH)

