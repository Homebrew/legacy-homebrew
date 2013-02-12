require 'formula'

class Rlwrap < Formula
  homepage 'http://utopia.knoware.nl/~hlub/rlwrap/'
  url 'http://utopia.knoware.nl/~hlub/rlwrap/rlwrap-0.37.tar.gz'
  sha1 'c8fc5e7798a7c618a22583c56fa38d344700cc2f'

  depends_on 'readline'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
