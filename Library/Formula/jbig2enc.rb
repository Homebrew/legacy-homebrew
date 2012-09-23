require 'formula'

class Jbig2enc < Formula
  homepage 'https://github.com/agl/jbig2enc'
  url 'https://github.com/agl/jbig2enc/tarball/0.28-dist'
  sha1 'ef45008c223f6e4e7c014e40dd6aefa181b71d8f'
  version '0.28'

  depends_on 'leptonica'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
