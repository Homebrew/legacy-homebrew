require 'formula'

class Ucl <Formula
  url 'http://www.oberhumer.com/opensource/ucl/download/ucl-1.03.tar.gz'
  homepage 'http://www.oberhumer.com/opensource/ucl/'
  md5 '852bd691d8abc75b52053465846fba34'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
