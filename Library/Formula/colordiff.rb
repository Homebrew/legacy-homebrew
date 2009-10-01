require 'brewkit'

class Colordiff <Formula
  url 'http://colordiff.sourceforge.net/colordiff-1.0.9.tar.gz'
  homepage 'http://colordiff.sourceforge.net/'
  md5 '31864847eaa4e900f72bbb6bbc64f1ec'

  def patches
    DATA
  end

  def install
    system "make DESTDIR=#{prefix} install"
  end
end

__END__
--- a/Makefile	2009-04-21 11:55:47.000000000 -0700
+++ b/Makefile	2009-09-30 12:55:43.000000000 -0700
@@ -1,5 +1,5 @@
-INSTALL_DIR=/usr/local/bin
-MAN_DIR=/usr/local/man/man1
+INSTALL_DIR=/bin
+MAN_DIR=/share/man/man1
 ETC_DIR=/etc
 VERSION=1.0.9
 DIST_FILES=COPYING INSTALL Makefile README \
@@ -22,14 +22,16 @@
 
 install:
 	install -d ${DESTDIR}${INSTALL_DIR}
+	install -d ${DESTDIR}${MAN_DIR}
+	install -d ${DESTDIR}${ETC_DIR}
 	sed -e "s%/etc%${ETC_DIR}%g" colordiff.pl > \
 	  ${DESTDIR}${INSTALL_DIR}/colordiff
 	chmod +x ${DESTDIR}${INSTALL_DIR}/colordiff
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
