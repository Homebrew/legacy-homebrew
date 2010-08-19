require 'formula'

class Exiv2 <Formula
  url 'http://www.exiv2.org/exiv2-0.19.tar.gz'
  homepage 'http://www.exiv2.org'
  md5 'f52fb75a2cb7512f1484deab76473e13'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
