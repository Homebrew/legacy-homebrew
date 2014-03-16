require 'formula'

class Metaproxy < Formula
  homepage 'http://www.indexdata.com/metaproxy'
  url 'http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.4.5.tar.gz'
  sha1 'f92002d6e713e9ad13fd526b4e4f49d349f9389a'

  depends_on 'pkg-config' => :build
  depends_on 'yazpp'
  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
