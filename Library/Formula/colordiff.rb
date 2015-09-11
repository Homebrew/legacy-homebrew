class Colordiff < Formula
  desc "Color-highlighted diff(1) output"
  homepage "http://www.colordiff.org/"
  url "http://www.colordiff.org/colordiff-1.0.15.tar.gz"
  sha256 "595ee4e9796ba02fad0b181e21df3ee34ae71d1611e301e146c0bf00c5269d45"

  bottle do
    cellar :any
    sha256 "ec28e4b2776cb039710428718fd0df6a246968aea0db6391c9222272cad9d601" => :el_capitan
    sha256 "c5ed797abdaedc5a5f163bafce625307249408afd87bd1a2d31b086af29e02d6" => :yosemite
    sha256 "a316bce78fc4bfd7fead8f6a6ce87161e9bd862e61882c72be60bcc42d248db1" => :mavericks
    sha256 "45232a4a2de9ccf1848b28593d2a870efaf38017b465fdb8f04e261f7ccad8e7" => :mountain_lion
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
