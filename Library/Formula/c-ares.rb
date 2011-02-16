require 'formula'

class CAres <Formula
  url 'http://c-ares.haxx.se/c-ares-1.7.4.tar.gz'
  homepage 'http://c-ares.haxx.se/'
  md5 'dd71e8f07d9f3c837e12a5416d1b7f73'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
