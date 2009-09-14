require 'brewkit'

class Ragel <Formula
  url 'http://www.complang.org/ragel/ragel-6.5.tar.gz'
  homepage 'http://www.complang.org/ragel/'
  md5 'bb152087079ad7a545dcdc955b752301'

  def install
    system "./configure", 
            "--prefix=#{prefix}", 
            "--disable-dependency-tracking"
    system "make install"
  end
end
