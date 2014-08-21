require 'formula'

class Lv < Formula
  homepage 'http://www.ff.iij4u.or.jp/~nrt/lv/'
  url 'http://www.ff.iij4u.or.jp/~nrt/freeware/lv451.tar.gz'
  version '4.51'
  sha1 '1a70299c27aa317a436976a557853858db4dcb5f'

  def patches
    DATA
  end

  def install
    cd 'build' do
      system "../src/configure", "--prefix=#{prefix}"
      system "make"
      bin.install 'lv'
      bin.install_symlink 'lv' => 'lgrep'
    end

    man1.install 'lv.1'
    (lib + 'lv').install 'lv.hlp'
  end
end

__END__
--- a/src/stream.c  2012-01-01 00:00:00.000000000 +0000
+++ b/src/stream.c  2012-01-01 00:00:00.000000000 +0000
@@ -41,7 +41,7 @@
 #include <begin.h>
 #include "stream.h"

-private byte *gz_filter = "zcat";
+private byte *gz_filter = "gzcat";
 private byte *bz2_filter = "bzcat";

 private stream_t *StreamAlloc()
