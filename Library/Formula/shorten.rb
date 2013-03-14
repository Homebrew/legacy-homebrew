require 'formula'

class Shorten < Formula
  homepage 'http://www.etree.org/shnutils/shorten/'
  url 'http://www.etree.org/shnutils/shorten/dist/src/shorten-3.6.1.tar.gz'
  sha1 'bd525ced0b9ba99a7a178c11647a853147977fa5'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
