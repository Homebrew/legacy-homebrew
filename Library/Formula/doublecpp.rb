require 'formula'

class Doublecpp < Formula
  homepage 'http://doublecpp.sourceforge.net/'
  url 'https://downloads.sourceforge.net/doublecpp/doublecpp-0.6.3.tar.gz'
  sha1 '53e972fda5af7cb412defa2d30def8937523bbae'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
