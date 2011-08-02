require 'formula'

class Mrtg < Formula
  url 'http://oss.oetiker.ch/mrtg/pub/mrtg-2.16.2.zip'
  homepage 'http://oss.oetiker.ch/mrtg/'
  md5 'c085b85d1f93f459cef9e889bf654fd5'

  depends_on 'gd'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
