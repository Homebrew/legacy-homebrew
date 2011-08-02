require 'formula'

class Ragel < Formula
  url 'http://www.complang.org/ragel/ragel-6.7.tar.gz'
  homepage 'http://www.complang.org/ragel/'
  md5 'f4423e0d8a6538dd4e61498fcfad3cec'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
