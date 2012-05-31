require 'formula'

class Yazpp < Formula
  url 'http://ftp.indexdata.dk/pub/yazpp/yazpp-1.2.8.tar.gz'
  homepage 'http://www.indexdata.com/yazpp'
  md5 '6f200ec3e196dc5f741701c54694b9d9'

  depends_on 'yaz'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
