require 'formula'

class CAres <Formula
  url 'http://c-ares.haxx.se/c-ares-1.7.3.tar.gz'
  homepage 'http://c-ares.haxx.se/'
  md5 '97ebef758804a6e9b6c0bc65d3c2c25a'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
