require 'formula'

class Bgpq3 < Formula
  desc "bgp filtering automation for Cisco and Juniper routers"
  homepage 'http://snar.spb.ru/prog/bgpq3/'
  url 'https://github.com/snar/bgpq3/archive/v0.1.30.tar.gz'
  sha1 'ba74b304eb7b3b7f5c0305d75222411baee9816f'
  head "https://github.com/snar/bgpq3.git"

  bottle do
    cellar :any
    sha256 "95674d0494d12f72694e626187a8d86afc190f659d7892e4c221a096f84c918d" => :yosemite
    sha256 "efa7ce918847349cc6e3c9751e8833cdb5d5ff14f69a5e303ec339abd5888ef8" => :mavericks
    sha256 "f3ba1d27e86678f9159da82b47e7597e829f4a9b6e847f63cd9b212909e986ca" => :mountain_lion
  end

  # Makefile: upstream has been informed of the patch through email (multiple
  # times) but no plans yet to incorporate it https://github.com/snar/bgpq3/pull/2
  # there was discussion about this patch for 0.1.18 and 0.1.19 as well
  patch :DATA

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
index c2d7e96..afec780 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -29,9 +29,10 @@ clean:
 	rm -rf *.o *.core core.* core

 install: bgpq3
+	if test ! -d @prefix@/bin ; then mkdir -p @prefix@/bin ; fi
 	${INSTALL} -c -s -m 755 bgpq3 @bindir@
-	if test ! -d @prefix@/man/man8 ; then mkdir -p @prefix@/man/man8 ; fi
-	${INSTALL} -m 644 bgpq3.8 @prefix@/man/man8
+	if test ! -d @mandir@/man8 ; then mkdir -p @mandir@/man8 ; fi
+	${INSTALL} -m 644 bgpq3.8 @mandir@/man8

 depend:
 	makedepend -- $(CFLAGS) -- $(SRCS)
