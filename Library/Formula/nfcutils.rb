require 'formula'

class Nfcutils < Formula
  url 'http://nfc-tools.googlecode.com/files/nfcutils-0.3.0.tar.gz'
  homepage 'http://code.google.com/p/nfc-tools/'
  md5 '161d640eb7f8d17762f57f7b27437f33'
  depends_on 'libnfc'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
