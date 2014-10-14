require 'formula'

class Flickcurl < Formula
  homepage 'http://librdf.org/flickcurl/'
  url 'http://download.dajobe.org/flickcurl/flickcurl-1.25.tar.gz'
  sha1 '35fc64dd698ad90d0f9d5622b7dfd322d8142082'

  depends_on 'pkg-config' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/flickcurl", "-h"
  end
end
