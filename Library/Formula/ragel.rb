require 'formula'

class Ragel <Formula
  url 'http://www.complang.org/ragel/ragel-6.6.tar.gz'
  homepage 'http://www.complang.org/ragel/'
  md5 '5c4366369f4934adc02bd71dc1a4ee1f'

  def install
    system "./configure", 
            "--prefix=#{prefix}", 
            "--disable-dependency-tracking"
    system "make install"
  end
end
