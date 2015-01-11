require 'formula'

class Flickcurl < Formula
  homepage 'http://librdf.org/flickcurl/'
  url 'http://download.dajobe.org/flickcurl/flickcurl-1.26.tar.gz'
  sha1 '547480030ce4f777bb35d98b43fe15ee3eeae0e0'

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
