require 'formula'

class Raptor < Formula
  url 'http://download.librdf.org/source/raptor2-2.0.3.tar.gz'
  homepage 'http://librdf.org/raptor/'
  md5 '46eff4b20f8752d1146a3e0c8b2168dd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
