require 'formula'

class Bgpq3 < Formula
  homepage 'http://snar.spb.ru/prog/bgpq3/'
  url 'http://snar.spb.ru/prog/bgpq3/bgpq3-0.1.19.tgz'
  sha1 '41a2afaeffb12e43048ca8771c6cc6e6392e0da5'

  def patches
    # Upstream has been informed of this patch through email
    DATA
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/bgpq3", "AS-ANY"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index afec780..569b4c9 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -1,5 +1,5 @@
 CC=@CC@
-CFLAGS=@CFLAGS@ @DEFS@ -g -Wall -I. -O0
+CFLAGS=@CFLAGS@ @DEFS@ -g -Wall -I. -O0 -DHAVE_STRLCPY
 LDADD=@LDFLAGS@ @LIBS@
 INSTALL=@INSTALL@

@@ -29,9 +29,10 @@ clean:
 	rm -rf *.o *.core core.* core
 
 install: bgpq3
+	if test ! -d @prefix@/bin ; then mkdir -p @prefix@/bin ; fi
 	${INSTALL} -c -s -m 755 bgpq3 @bindir@
-	if test ! -d @prefix@/man/man8 ; then mkdir -p @prefix@/man/man8 ; fi
-	${INSTALL} -m 644 bgpq3.8 @prefix@/man/man8
+	if test ! -d @mandir@/man/man8 ; then mkdir -p @mandir@/man/man8 ; fi
+	${INSTALL} -m 644 bgpq3.8 @mandir@/man/man8
 
 depend: 
 	makedepend -- $(CFLAGS) -- $(SRCS)
