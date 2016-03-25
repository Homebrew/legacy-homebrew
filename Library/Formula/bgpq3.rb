class Bgpq3 < Formula
  desc "bgp filtering automation for Cisco and Juniper routers"
  homepage "http://snar.spb.ru/prog/bgpq3/"
  url "https://github.com/snar/bgpq3/archive/v0.1.31.tar.gz"
  sha256 "839da59b153b2c748ca021d742cb9da248681e323f380e614ac546b796fbe71b"
  head "https://github.com/snar/bgpq3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "30533caf28a47fc722fc35791ef6818e725535672515599e486baa117faa05ed" => :el_capitan
    sha256 "f0be355cc0ce42364f31d1a0190d4239d0a05ee3545d166ec4630c305af23dd0" => :yosemite
    sha256 "66251ef2771eef19ea08c52961d142f787a4b0184ad73905a5f80d3191700306" => :mavericks
    sha256 "e4c36bd2ac02efee5c2f74bbf4c207e552d95069773713e3b25c27493a23ebd3" => :mountain_lion
  end

  devel do
    url "https://github.com/snar/bgpq3/archive/0.1.32-rc5.tar.gz"
    sha256 "80da4ff47cc527f6c2d33eb39e41a11a75e71f85d94ce5e8206d9c6c87107c19"
    version "0.1.32-rc5"
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
