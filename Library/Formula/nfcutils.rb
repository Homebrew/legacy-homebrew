require 'formula'

class Nfcutils < Formula
  homepage 'https://code.google.com/p/nfc-tools/'
  url 'https://nfc-tools.googlecode.com/files/nfcutils-0.3.2.tar.gz'
  sha1 'e560ba7683175257ef9e72838b9f02cf75ce99b8'

  depends_on 'pkg-config' => :build
  depends_on 'libnfc'
  depends_on 'libusb'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
