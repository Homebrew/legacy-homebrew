require 'formula'

class Cgvg < Formula
  homepage 'http://www.uzix.org/cgvg.html'
  url 'http://www.uzix.org/cgvg/cgvg-1.6.2.tar.gz'
  version '1.6.2'
  sha1 '24f460d75de95969e30d8a5187d037119ac79ad2'

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install" # if this fails, try separate make/make install steps
  end

  def test
    system "which cg"
  end
end
