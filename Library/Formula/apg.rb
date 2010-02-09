require 'formula'

class Apg <Formula
  url 'http://www.adel.nursat.kz/apg/download/apg-2.2.3.tar.gz'
  homepage 'http://www.adel.nursat.kz/apg/'
  md5 '3b3fc4f11e90635519fe627c1137c9ac'

  def patches
    DATA
  end

  def install
#    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make standalone"
    system "make install INSTALL_PREFIX=#{prefix}"
  end
end

__END__
--- ./Makefile.old	2010-02-09 16:47:32.000000000 +0200
+++ ./Makefile	2010-02-09 16:47:44.000000000 +0200
@@ -13,8 +13,6 @@
 #
 # You should comment the line below ('LIBS= -lcrypt')for QNX RTP
 # 6.1.0, OpenBSD 2.8 and above, WIN32 (+MinGW)
-LIBS = -lcrypt
-LIBM = -lm
 # Use lines below for cygwin
 # LIBS = 
 # LIBM =
@@ -109,23 +107,25 @@
 	strip ${CS_PROGNAME}
 	strip ${BFM_PROGNAME}
 
+.PHONY: install
+
 install:
 	if test -x ./apg; then \
 ./mkinstalldirs ${INSTALL_PREFIX}${APG_BIN_DIR}; \
 ./mkinstalldirs ${INSTALL_PREFIX}${APG_MAN_DIR}; \
-./install-sh -c -m 0755 -o root -g ${FIND_GROUP} ./apg ${INSTALL_PREFIX}${APG_BIN_DIR}; \
+./install-sh -c -m 0755 ./apg ${INSTALL_PREFIX}${APG_BIN_DIR}; \
 ./install-sh -c -m 0444 ./doc/man/apg.1 ${INSTALL_PREFIX}${APG_MAN_DIR}; \
 fi
 	if test -x ./apgd; then \
 ./mkinstalldirs ${INSTALL_PREFIX}${APGD_BIN_DIR}; \
 ./mkinstalldirs ${INSTALL_PREFIX}${APGD_MAN_DIR}; \
-./install-sh -c -m 0755 -o root -g ${FIND_GROUP} ./apgd ${INSTALL_PREFIX}${APGD_BIN_DIR}; \
+./install-sh -c -m 0755 ./apgd ${INSTALL_PREFIX}${APGD_BIN_DIR}; \
 ./install-sh -c -m 0444 ./doc/man/apgd.8 ${INSTALL_PREFIX}${APGD_MAN_DIR}; \
 fi
 	if test -x ./apgbfm; then \
 ./mkinstalldirs ${INSTALL_PREFIX}${APG_BIN_DIR}; \
 ./mkinstalldirs ${INSTALL_PREFIX}${APG_MAN_DIR}; \
-./install-sh -c -m 0755 -o root -g ${FIND_GROUP} ./apgbfm ${INSTALL_PREFIX}${APG_BIN_DIR}; \
+./install-sh -c -m 0755 ./apgbfm ${INSTALL_PREFIX}${APG_BIN_DIR}; \
 ./install-sh -c -m 0444 ./doc/man/apgbfm.1 ${INSTALL_PREFIX}${APG_MAN_DIR}; \
 fi
