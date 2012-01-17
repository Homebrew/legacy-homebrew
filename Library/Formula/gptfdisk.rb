require 'formula'

class Gptfdisk < Formula
  url 'http://sourceforge.net/projects/gptfdisk/files/gptfdisk/0.8.1/gptfdisk-0.8.1.tar.gz'
  homepage 'http://www.rodsbooks.com/gdisk/'
  md5 'f556297cce00ef096de11d504d85b9a9'

  depends_on 'popt'
  depends_on 'icu4c'

  def patches; DATA; end

  def install
    icu4c = Formula.factory('icu4c')
    ENV.append 'LDFLAGS',"-L#{icu4c.lib}"
    ENV.append 'CXXFLAGS',"-O2 -Wall -D_FILE_OFFSET_BITS=64 -D USE_UTF16  -I#{icu4c.include} -g"
    system "make -f Makefile.mac"
    sbin.install ['gdisk','cgdisk','sgdisk','fixparts']
    man8.install ['gdisk.8','cgdisk.8','sgdisk.8','fixparts.8']
  end

  def test
    system "echo | gdisk"
  end
end
__END__
diff -u a/Makefile.mac b/Makefile.mac
--- a/Makefile.mac	2012-01-17 00:38:25.000000000 +0100
+++ b/Makefile.mac	2012-01-17 01:19:21.000000000 +0100
@@ -1,8 +1,4 @@
-CC=gcc
-CXX=g++
 CFLAGS=-O2 -D_FILE_OFFSET_BITS=64 -g
-CXXFLAGS=-O2 -Wall -D_FILE_OFFSET_BITS=64 -D USE_UTF16 -I/sw/include -I/usr/local/include -I/opt/local/include -g
-#CXXFLAGS=-O2 -Wall -D_FILE_OFFSET_BITS=64 -I /usr/local/include -I/opt/local/include -g
 LIB_NAMES=crc32 support guid gptpart mbrpart basicmbr mbr gpt bsd parttypes attributes diskio diskio-unix
 MBR_LIBS=support diskio diskio-unix basicmbr mbrpart
 #LIB_SRCS=$(NAMES:=.cc)
@@ -15,15 +11,15 @@
 
 gdisk:	$(LIB_OBJS) gpttext.o gdisk.o
 #	$(CXX) $(LIB_OBJS) gpttext.o gdisk.o -o gdisk
-	$(CXX) $(LIB_OBJS) -L/usr/lib -licucore gpttext.o gdisk.o -o gdisk
+	$(CXX) $(LIB_OBJS) $(LDFLAGS) -licuuc -licuio gpttext.o gdisk.o -o gdisk
 
 cgdisk: $(LIB_OBJS) cgdisk.o gptcurses.o
 #	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o $(LDFLAGS) -lncurses -o sgdisk
-	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o $(LDFLAGS) -licucore -lncurses -o cgdisk
+	$(CXX) $(LIB_OBJS) cgdisk.o gptcurses.o $(LDFLAGS) -licuuc -licuio -lncurses -o cgdisk
 
 sgdisk: $(LIB_OBJS) gptcl.o sgdisk.o
 #	$(CXX) $(LIB_OBJS) gptcl.o sgdisk.o -L/sw/lib -lpopt -o sgdisk
-	$(CXX) $(LIB_OBJS) gptcl.o sgdisk.o -L/sw/lib -licucore -lpopt -o sgdisk
+	$(CXX) $(LIB_OBJS) gptcl.o sgdisk.o $(LDFLAGS) -licuuc -licuio -lpopt -o sgdisk
 
 fixparts: $(MBR_LIB_OBJS) fixparts.o
 	$(CXX) $(MBR_LIB_OBJS) fixparts.o $(LDFLAGS) -o fixparts
