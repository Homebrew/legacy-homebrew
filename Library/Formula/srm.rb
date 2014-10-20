require "formula"

class Srm < Formula
  homepage "http://www.thc.org/"
  url "https://www.thc.org/releases/secure_delete-3.1.tar.gz"
  sha1 "ce6391003587b37bd3713a967de04de1f0759107"

  patch :DATA

  def install
    args = ["--prefix", prefix]

    system "./configure", *args

    system "make"
    # MAN1DIR, relative to the given prefix
    system "make", "install", "DESTDIR=#{prefix}"
  end
end

__END__
--- secure_delete-3.1/Makefile	2003-10-29 14:07:06.000000000 -0700
+++ ./Makefile	2014-10-19 17:47:01.000000000 -0700
@@ -1,13 +1,13 @@
-CC=gcc
+CC=clang
 OPT=-O2 -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE
 #OPT=-Wall -D_DEBUG_ -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE
-INSTALL_DIR=/usr/local/bin
-MAN_DIR=/usr/local/man
-DOC_DIR=/usr/share/doc/secure_delete
-OPT_MOD=-D__KERNEL__ -DMODULE -fomit-frame-pointer -fno-strict-aliasing -pipe -mpreferred-stack-boundary=2
+INSTALL_DIR=${DESTDIR}/bin
+MAN_DIR=${DESTDIR}/man
+DOC_DIR=${DESTDIR}/share/doc/secure_delete
+OPT_MOD=-D__KERNEL__ -DMODULE -fomit-frame-pointer -fno-strict-aliasing -pipe
 #LD_MOD=-r
 
-all: sdel-lib.o srm sfill sswap smem sdel-mod.o
+all: sdel-lib.o srm sfill sswap smem
 	@echo
 	@echo "A Puritan is someone who is deathly afraid that someone, somewhere, is"
 	@echo "having fun."
@@ -21,16 +21,16 @@
 sdel-lib.o: sdel-lib.c
 	$(CC) ${OPT} -c sdel-lib.c
 
-srm: srm.c
+srm: srm.c sdel-lib.o
 	$(CC) ${OPT} -o srm srm.c sdel-lib.o
 	-strip srm
-sfill: sfill.c
+sfill: sfill.c sdel-lib.o
 	$(CC) ${OPT} -o sfill sfill.c sdel-lib.o
 	-strip sfill
-sswap: sswap.c
+sswap: sswap.c sdel-lib.o
 	$(CC) ${OPT} -o sswap sswap.c sdel-lib.o
 	-strip sswap
-smem: smem.c
+smem: smem.c sdel-lib.o
 	$(CC) ${OPT} -o smem smem.c sdel-lib.o
 	-strip smem
 
@@ -47,8 +47,6 @@
 	chmod 644 ${MAN_DIR}/man1/srm.1 ${MAN_DIR}/man1/sfill.1 ${MAN_DIR}/man1/sswap.1 ${MAN_DIR}/man1/smem.1
 	mkdir -p -m 755 ${DOC_DIR} 2> /dev/null
 	cp -f CHANGES FILES README secure_delete.doc usenix6-gutmann.doc ${DOC_DIR}
-	-test -e sdel-mod.o && cp -f sdel-mod.o /lib/modules/`uname -r`/kernel/drivers/char
-#	@-test '!' -e sdel-mod.o -a `uname -s` = 'Linux' && echo "type \"make sdel-mod install\" to compile and install the Linux loadable kernel module for secure delete"
 	@echo
 	@echo "If men could get pregnant, abortion would be a sacrament."
 	@echo
