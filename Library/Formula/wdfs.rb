require 'formula'

class Wdfs < Formula
  url 'http://noedler.de/projekte/wdfs/wdfs-1.4.2.tar.gz'
  homepage 'http://noedler.de/projekte/wdfs/'
  md5 '628bb44194d04c1cf8aacc446ed0a230'

  depends_on 'neon'
  depends_on 'fuse4x'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "wdfs -v"
  end
end
