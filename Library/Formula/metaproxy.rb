require 'formula'

class Metaproxy < Formula
  homepage 'http://www.indexdata.com/metaproxy'
  url 'http://ftp.indexdata.dk/pub/metaproxy/metaproxy-1.4.0.tar.gz'
  sha1 '032c5d5334aa34eb239cdac7b2579d83844ecba2'

  depends_on 'pkg-config' => :build
  depends_on 'yazpp'
  depends_on 'boost'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
