require 'formula'

class Rlwrap < Formula
  url 'http://utopia.knoware.nl/~hlub/rlwrap/rlwrap-0.37.tar.gz'
  sha1 'c8fc5e7798a7c618a22583c56fa38d344700cc2f'
  homepage 'http://utopia.knoware.nl/~hlub/rlwrap/'

  depends_on 'readline'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
