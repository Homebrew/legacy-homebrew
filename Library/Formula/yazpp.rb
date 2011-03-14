require 'formula'

class Yazpp < Formula
  url 'http://ftp.indexdata.dk/pub/yazpp/yazpp-1.2.3.tar.gz'
  homepage 'http://www.indexdata.com/yazpp'
  md5 '9144237027ce43540b8f5fd7577f5432'

  depends_on 'yaz'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
