require 'formula'

class Curl <Formula
  url 'http://curl.haxx.se/download/curl-7.21.2.tar.bz2'
  homepage 'http://curl.haxx.se/'
  md5 'ca96df88e044c7c25d19692ec8b250b2'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
