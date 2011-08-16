require 'formula'

class Libogg < Formula
  homepage 'http://www.xiph.org/ogg/'
  url 'http://downloads.xiph.org/releases/ogg/libogg-1.3.0.tar.gz'
  md5 '0a7eb40b86ac050db3a789ab65fe21c2'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
