class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "http://www.colordiff.org/"
  url "http://www.colordiff.org/colordiff-1.0.16.tar.gz"
  sha256 "eaf1cfe17dd0e820d38a0b24b0a402eba68b32e9bf9e7791ca2d1831029f138b"

  bottle do
    cellar :any_skip_relocation
    sha256 "164196a68ad856b48ddff2de74f63eea098e90a9c211a4ab441b84861bc49136" => :el_capitan
    sha256 "c31580d91f2bc3c2988957a391c8d30844b6680808811b6fe35e042d6151c68e" => :yosemite
    sha256 "386b872c9ce130d237efcf4874c4e06582e56bc243fe89c7cd355e72f6d0f048" => :mavericks
  end

  patch :DATA

  def install
    man1.mkpath
    system "make", "INSTALL_DIR=#{bin}",
                   "ETC_DIR=#{etc}",
                   "MAN_DIR=#{man1}",
                   "install"
  end

  test do
    cp HOMEBREW_PREFIX+"bin/brew", "brew1"
    cp HOMEBREW_PREFIX+"bin/brew", "brew2"
    system "#{bin}/colordiff", "brew1", "brew2"
  end
end

__END__
diff --git a/Makefile b/Makefile
index 6ccbfc7..e5d64e7 100644
--- a/Makefile
+++ b/Makefile
@@ -28,8 +29,8 @@ install:
 	if [ ! -f ${DESTDIR}${INSTALL_DIR}/cdiff ] ; then \
 	  install cdiff.sh ${DESTDIR}${INSTALL_DIR}/cdiff; \
 	fi
-	install -Dm 644 colordiff.1 ${DESTDIR}${MAN_DIR}/colordiff.1
-	install -Dm 644 cdiff.1 ${DESTDIR}${MAN_DIR}/cdiff.1
+	install -m 644 colordiff.1 ${DESTDIR}${MAN_DIR}/colordiff.1
+	install -m 644 cdiff.1 ${DESTDIR}${MAN_DIR}/cdiff.1
 	if [ -f ${DESTDIR}${ETC_DIR}/colordiffrc ]; then \
 	  mv -f ${DESTDIR}${ETC_DIR}/colordiffrc \
 	    ${DESTDIR}${ETC_DIR}/colordiffrc.old; \
@@ -37,7 +38,6 @@ install:
 	  install -d ${DESTDIR}${ETC_DIR}; \
 	fi
 	cp colordiffrc ${DESTDIR}${ETC_DIR}/colordiffrc
-	-chown root.root ${DESTDIR}${ETC_DIR}/colordiffrc
 	chmod 644 ${DESTDIR}${ETC_DIR}/colordiffrc

 uninstall:
