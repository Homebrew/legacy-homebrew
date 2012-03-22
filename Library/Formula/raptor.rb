require 'formula'

class Raptor < Formula
  url 'http://download.librdf.org/source/raptor2-2.0.7.tar.gz'
  homepage 'http://librdf.org/raptor/'
  md5 '699073463467dc8eded2ca89de2ab2ea'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
