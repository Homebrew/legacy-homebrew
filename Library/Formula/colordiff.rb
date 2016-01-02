class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "http://www.colordiff.org/"
  url "http://www.colordiff.org/colordiff-1.0.16.tar.gz"
  sha256 "eaf1cfe17dd0e820d38a0b24b0a402eba68b32e9bf9e7791ca2d1831029f138b"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "745965f6a9e37d91242b421a17697ce67328d390d2d94dd5b449d5c0dbae9e65" => :el_capitan
    sha256 "e0e8a697a98972c3f336a867d4da2124b5b997bfd9c77a2fdca84d0cd1de541f" => :yosemite
    sha256 "add0c4af1ad602b31f674b921435aa826951e125480220b6f66b8de406123345" => :mavericks
  end

  conflicts_with "cdiff", :because => "both install `cdiff` binaries"

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
