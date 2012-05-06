require 'formula'

class Gptfdisk < Formula
  homepage 'http://www.rodsbooks.com/gdisk/'
  url 'http://sourceforge.net/projects/gptfdisk/files/gptfdisk/0.8.2/gptfdisk-0.8.2.tar.gz'
  md5 'a6a5beb047d65c0cda4eacc6b5625a19'

  depends_on 'popt'
  depends_on 'icu4c'

  def patches; DATA; end

  def install
    system "make -f Makefile.mac"
    sbin.install ['gdisk','cgdisk','sgdisk','fixparts']
    man8.install ['gdisk.8','cgdisk.8','sgdisk.8','fixparts.8']
  end

  def test
    system "echo | #{sbin}/gdisk"
  end
end
__END__
diff -u a/Makefile.mac b/Makefile.mac
--- a/Makefile.mac	2012-01-22 20:44:28.000000000 +0100
+++ b/Makefile.mac	2012-02-21 01:00:34.000000000 +0100
@@ -1,11 +1,7 @@
-CC=gcc
-CXX=g++
 CFLAGS=-O2 -D_FILE_OFFSET_BITS=64 -g
-CXXFLAGS=-O2 -Wall -D_FILE_OFFSET_BITS=64 -D USE_UTF16 -I/sw/include -I/usr/local/include -I/opt/local/include -g
-#CXXFLAGS=-O2 -Wall -D_FILE_OFFSET_BITS=64 -I /usr/local/include -I/opt/local/include -g
+CXXFLAGS+=-O2 -Wall -D_FILE_OFFSET_BITS=64 -D USE_UTF16 -g
 LIB_NAMES=crc32 support guid gptpart mbrpart basicmbr mbr gpt bsd parttypes attributes diskio diskio-unix
 MBR_LIBS=support diskio diskio-unix basicmbr mbrpart
-#LIB_SRCS=$(NAMES:=.cc)
 LIB_OBJS=$(LIB_NAMES:=.o)
 MBR_LIB_OBJS=$(MBR_LIBS:=.o)
 LIB_HEADERS=$(LIB_NAMES:=.h)
@@ -14,17 +10,14 @@
 all:	gdisk sgdisk cgdisk fixparts

 gdisk:	$(LIB_OBJS) gpttext.o gdisk.o
-#	$(CXX) $(LIB_OBJS) gpttext.o gdisk.o -o gdisk
-	$(CXX) $(LIB_OBJS) -L/usr/lib -licucore gpttext.o gdisk.o -o gdisk
+	$(CXX) $(LIB_OBJS) $(LDFLAGS) -licuuc -licuio gpttext.o gdisk.o -o gdisk

 cgdisk: $(LIB_OBJS) cgdisk.o gptcurses.o
-#	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o $(LDFLAGS) -lncurses -o sgdisk
-	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o $(LDFLAGS) -licucore -lncurses -o cgdisk
+	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o $(LDFLAGS) -licuuc -licuio -lncurses -o cgdisk

 sgdisk: $(LIB_OBJS) gptcl.o sgdisk.o
-#	$(CXX) $(LIB_OBJS) gptcl.o sgdisk.o -L/sw/lib -lpopt -o sgdisk
-	$(CXX) $(LIB_OBJS) gptcl.o sgdisk.o -L/sw/lib -licucore -lpopt -o sgdisk
-
+	$(CXX) $(LIB_OBJS) gptcl.o sgdisk.o $(LDFLAGS) -licuuc -licuio -lpopt -o sgdisk
+
 fixparts: $(MBR_LIB_OBJS) fixparts.o
	$(CXX) $(MBR_LIB_OBJS) fixparts.o $(LDFLAGS) -o fixparts
