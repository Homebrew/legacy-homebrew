require 'formula'

class Metaproxy < Formula
  homepage 'http://www.indexdata.com/metaproxy'
  url 'http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.4.3.tar.gz'
  sha1 '25ca53ce1b57204940fab21304669f93aa10cd74'

  depends_on 'pkg-config' => :build
  depends_on 'yazpp'
  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
