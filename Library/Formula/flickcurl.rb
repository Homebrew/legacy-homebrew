require 'formula'

class Flickcurl < Formula
  homepage 'http://librdf.org/flickcurl/'
  url 'http://download.dajobe.org/flickcurl/flickcurl-1.22.tar.gz'
  md5 '33106156f9a9e538b5787f92db717f5d'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/flickcurl -h"
  end
end
