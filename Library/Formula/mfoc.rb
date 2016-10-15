require 'formula'

class Mfoc < Formula
  homepage 'http://code.google.com/p/mfoc/'
  url 'http://mfoc.googlecode.com/files/mfoc-0.10.7.tar.bz2'
  sha1 '162a464baf6498926a72383c6b0040654321012d'
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'libnfc'
  depends_on 'libusb'
  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
  test do
    system "false"
  end
end
