require 'formula'

class Yazpp < Formula
  homepage 'http://www.indexdata.com/yazpp'
  url 'http://ftp.indexdata.dk/pub/yazpp/yazpp-1.5.0.tar.gz'
  sha1 '0e6bb1a0da1770086823a4170b6efdf7b045d689'

  depends_on 'yaz'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
