require 'formula'

class Shorten < Formula
  url 'http://www.etree.org/shnutils/shorten/dist/src/shorten-3.6.1.tar.gz'
  homepage 'http://www.etree.org/shnutils/shorten/'
  sha1 'bd525ced0b9ba99a7a178c11647a853147977fa5'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
