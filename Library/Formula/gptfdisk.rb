require 'formula'

class Gptfdisk < Formula
  homepage 'http://www.rodsbooks.com/gdisk/'
  url 'http://sourceforge.net/projects/gptfdisk/files/gptfdisk/0.8.5/gptfdisk-0.8.5.tar.gz'
  sha1 'fdff85df2515d5c11d5dc6fdf726a0d65f5136d4'

  depends_on 'popt'

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
--- a/Makefile.mac	2012-05-30 08:38:43.000000000 -0700
+++ a/Makefile.mac	2012-12-02 16:02:56.000000000 -0800
@@ -1,5 +1,5 @@
-CC=gcc
-CXX=g++
+#CC=gcc
+#CXX=g++
 CFLAGS=-O2 -D_FILE_OFFSET_BITS=64 -g
 CXXFLAGS=-O2 -Wall -D_FILE_OFFSET_BITS=64 -D USE_UTF16 -I/sw/include -I/usr/local/include -I/opt/local/include -g
 #CXXFLAGS=-O2 -Wall -D_FILE_OFFSET_BITS=64 -I /usr/local/include -I/opt/local/include -g
