require 'formula'

class Gtkwave < Formula
  homepage 'http://gtkwave.sourceforge.net/'
  url 'http://gtkwave.sourceforge.net/gtkwave-3.3.57.tar.gz'
  sha1 'ec81f03bac12852f24717159fa202c5077dfbe68'

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
