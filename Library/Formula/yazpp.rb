require 'formula'

class Yazpp < Formula
  homepage 'http://www.indexdata.com/yazpp'
  url 'http://ftp.indexdata.dk/pub/yazpp/yazpp-1.4.1.tar.gz'
  sha1 '0ad0676b1d9decdeff996fd531a15705082e6a77'

  depends_on 'yaz'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
