require 'formula'

class Metaproxy < Formula
  homepage 'http://www.indexdata.com/metaproxy'
  url 'http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.3.62.tar.gz'
  sha1 'ceeb395d95a1d2ae2a266cc7d65be4e0569a8d9b'

  depends_on 'pkg-config' => :build
  depends_on 'yazpp'
  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
