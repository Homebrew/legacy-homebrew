require 'formula'

class CAres < Formula
  url 'http://c-ares.haxx.se/download/c-ares-1.7.5.tar.gz'
  homepage 'http://c-ares.haxx.se/'
  md5 '800875fc23cd8e1924d8af9172ed33e7'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
