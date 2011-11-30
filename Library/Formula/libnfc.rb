require 'formula'

class Libnfc < Formula
  url 'http://libnfc.googlecode.com/files/libnfc-1.5.1.tar.gz'
  homepage 'http://www.libnfc.org/'
  md5 '81e3e59496060dc495c95844654a8038'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
