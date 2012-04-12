require 'formula'

class Metaproxy < Formula
  url 'http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.3.25.tar.gz'
  homepage 'http://www.indexdata.com/metaproxy'
  md5 '085df43c5b31adef9c2fac6ba0325061'

  depends_on 'yazpp'
  depends_on 'boost'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
