require 'formula'

class Doublecpp < Formula
  url 'http://downloads.sourceforge.net/doublecpp/doublecpp-0.6.3.tar.gz'
  homepage 'http://doublecpp.sourceforge.net/'
  sha1 '53e972fda5af7cb412defa2d30def8937523bbae'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
