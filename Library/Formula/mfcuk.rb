require 'formula'

class Mfcuk < Formula
  homepage 'http://code.google.com/p/mfcuk/'
  url 'https://mfcuk.googlecode.com/files/mfcuk-0.3.8.tar.gz'
  sha1 '2a8259440ac5bed8516c8d771a945b713dacd2bc'

  depends_on 'pkg-config' => :build
  depends_on 'libnfc'
  depends_on 'libusb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mfcuk", "-h"
  end
end
