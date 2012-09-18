require 'formula'

class Metaproxy < Formula
  homepage 'http://www.indexdata.com/metaproxy'
  url 'http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.3.38.tar.gz'
  sha1 '33332fec1d11744f585d1ebd4074d2da127565a7'

  depends_on 'yazpp'
  depends_on 'boost'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
