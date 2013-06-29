require 'formula'

class Cdf < Formula
  homepage 'http://bmp-plugins.berlios.de/misc/cdf/cdf.html'
  url 'http://download.berlios.de/bmp-plugins/cdf-0.2.tar.gz'
  sha1 '5f5d0c1f1003d9ad3c3cbbda1d8159e9fe10768a'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
