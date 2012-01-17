require 'formula'

class Freexl < Formula
  homepage 'https://www.gaia-gis.it/fossil/freexl/index'
  url 'http://www.gaia-gis.it/gaia-sins/freexl-1.0.0b.tar.gz'
  md5 'e2e1c59eb2883d825782dfe8fe244207'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
