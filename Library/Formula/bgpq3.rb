require 'formula'

class Bgpq3 < Formula
  homepage 'http://snar.spb.ru/prog/bgpq3/'
  url 'http://snar.spb.ru/prog/bgpq3/bgpq3-0.1.19.tgz'
  sha1 '41a2afaeffb12e43048ca8771c6cc6e6392e0da5'

  # Upstream has been informed of this patch through email  
  def patches
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
diff -u a/Makefile.in b/Makefile.in
--- a/Makefile.in  2013-08-28 18:56:54.000000000 +0200
+++ b/Makefile.in    2013-08-28 18:56:25.000000000 +0200
@@ -29,6 +29,7 @@
    rm -rf *.o *.core core.* core

 install: bgpq3
+   if test ! -d @prefix@/bin; then mkdir -p @prefix@/bin; fi
    ${INSTALL} -c -s -m 755 bgpq3 @bindir@
    if test ! -d @prefix@/man/man8 ; then mkdir -p @prefix@/man/man8 ; fi
    ${INSTALL} -m 644 bgpq3.8 @prefix@/man/man8
