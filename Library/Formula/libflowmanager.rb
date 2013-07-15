require 'formula'

class Libflowmanager < Formula
  homepage 'http://research.wand.net.nz/software/libflowmanager.php'
  url 'http://research.wand.net.nz/software/libflowmanager/libflowmanager-2.0.4.tar.gz'
  sha1 'fba31188c912433d3496bb0249da2a5d029a7b2e'

  depends_on 'libtrace'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
