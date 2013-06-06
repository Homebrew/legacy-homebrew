require 'formula'

class Jbig2enc < Formula
  homepage 'https://github.com/agl/jbig2enc'
  url 'https://github.com/agl/jbig2enc/archive/0.28-dist.tar.gz'
  sha1 'd2d73f732168eeb6fa18962dbe7743337363c3b6'
  version '0.28'

  depends_on 'leptonica'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
