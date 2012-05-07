require 'formula'

class Wdfs < Formula
  homepage 'http://noedler.de/projekte/wdfs/'
  url 'http://noedler.de/projekte/wdfs/wdfs-1.4.2.tar.gz'
  md5 '628bb44194d04c1cf8aacc446ed0a230'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'neon'
  depends_on 'fuse4x'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/wdfs -v"
  end
end
