require 'formula'

class Metaproxy < Formula
  url 'http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.2.1.tar.gz'
  homepage 'http://www.indexdata.com/metaproxy'
  md5 '201af5bc981de16d16d27e0287c6a495'

  depends_on 'yazpp'
  depends_on 'boost'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
