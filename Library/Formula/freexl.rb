require 'formula'

class Freexl < Formula
  homepage 'https://www.gaia-gis.it/fossil/freexl/index'
  url 'http://www.gaia-gis.it/gaia-sins/freexl-1.0.0b.tar.gz'
  md5 '5a9c422ed1af7487b626889f3cace2dd'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
