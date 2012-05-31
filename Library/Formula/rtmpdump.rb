require 'formula'

class Rtmpdump < Formula
  url 'http://rtmpdump.mplayerhq.hu/download/rtmpdump-2.3.tgz'
  homepage 'http://rtmpdump.mplayerhq.hu'
  md5 'eb961f31cd55f0acf5aad1a7b900ef59'

  head 'git://git.ffmpeg.org/rtmpdump'

  depends_on 'openssl' if MacOS.leopard?

  fails_with :llvm do
    # note: as of LLVM build 2336, this still has runtime issues
    cause "Crashes at runtime"
  end

  # Use dylib instead of so
  def patches; DATA; end unless ARGV.build_head?

  def install
    ENV.deparallelize
    sys_type = ARGV.build_head? ? "darwin" : "posix"
    system "make", "CC=#{ENV.cc}",
                   "XCFLAGS=#{ENV.cflags}",
                   "XLDFLAGS=#{ENV.ldflags}",
                   "MANDIR=#{man}",
                   "SYS=#{sys_type}",
                   "prefix=#{prefix}",
                   "install"
  end
end

__END__
--- rtmpdump-2.3/librtmp/Makefile.orig	2010-07-30 23:05:25.000000000 +0200
+++ rtmpdump-2.3/librtmp/Makefile	2010-07-30 23:08:23.000000000 +0200
@@ -25,7 +25,7 @@
 CRYPTO_REQ=$(REQ_$(CRYPTO))
 CRYPTO_DEF=$(DEF_$(CRYPTO))
 
-SO_posix=so.0
+SO_posix=dylib
 SO_mingw=dll
 SO_EXT=$(SO_$(SYS))
 
@@ -61,7 +61,7 @@
 	$(AR) rs $@ $?
 
 librtmp.$(SO_EXT): $(OBJS)
-	$(CC) -shared -Wl,-soname,$@ $(LDFLAGS) -o $@ $^ $> $(CRYPTO_LIB)
+	$(CC) -shared $(LDFLAGS) -o $@ $^ $> $(CRYPTO_LIB)
 	ln -sf $@ librtmp.so
 
 log.o: log.c log.h Makefile
@@ -87,5 +87,8 @@
 	cp librtmp.so.0 $(LIBDIR)
 	cd $(LIBDIR); ln -sf librtmp.so.0 librtmp.so
 
+install_dylib:	librtmp.dylib
+	cp librtmp.dylib $(LIBDIR)
+
 install_dll:	librtmp.dll
 	cp librtmp.dll $(BINDIR)

