require 'formula'

class Libnfc < Formula
  url 'http://libnfc.googlecode.com/files/libnfc-1.5.0.tar.gz'
  homepage 'http://www.libnfc.org/'
  md5 '569d85c36cd68f6e6560c9d78b46788f'

  depends_on 'libusb-compat'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
