require 'formula'

class Libresample < Formula
  homepage 'https://ccrma.stanford.edu/~jos/resample/Available_Software.html'
  url 'http://ftp.de.debian.org/debian/pool/main/libr/libresample/libresample_0.1.3.orig.tar.gz'
  sha1 '85339a6114627e27010856f42a3948a545ca72de'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    lib.install 'libresample.a'
    include.install 'include/libresample.h'
  end
end
