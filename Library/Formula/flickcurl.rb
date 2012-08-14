require 'formula'

class Flickcurl < Formula
  homepage 'http://librdf.org/flickcurl/'
  url 'http://download.dajobe.org/flickcurl/flickcurl-1.22.tar.gz'
  sha1 '38f427262bc76c23ac4ab31ed4df6c6022c5d3ec'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/flickcurl -h"
  end
end
