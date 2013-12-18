require 'formula'

class Gtkwave < Formula
  homepage 'http://gtkwave.sourceforge.net/'
  url 'http://gtkwave.sourceforge.net/gtkwave-3.3.52.tar.gz'
  sha1 'd86b6225f878f62130f6dd4b609c590aaf8f87dc'

  depends_on 'pkg-config' => :build
  depends_on 'gtk+'
  depends_on 'xz'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
