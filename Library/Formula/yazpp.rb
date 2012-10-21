require 'formula'

class Yazpp < Formula
  homepage 'http://www.indexdata.com/yazpp'
  url 'http://ftp.indexdata.dk/pub/yazpp/yazpp-1.3.2.tar.gz'
  sha1 'a4290f802eabee6816e3948dd7904243f1711c27'

  depends_on 'yaz'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
