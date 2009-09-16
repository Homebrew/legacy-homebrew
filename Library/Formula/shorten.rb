require 'brewkit'

class Shorten <Formula
  @url='http://www.etree.org/shnutils/shorten/dist/src/shorten-3.6.1.tar.gz'
  @homepage='http://www.etree.org/shnutils/shorten/'
  @md5='fb59c16fcedc4f4865d277f6e45866a7'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
