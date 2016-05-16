class Mfcuk < Formula
  desc "MiFare Classic Universal toolKit"
  homepage "https://github.com/nfc-tools/mfcuk"
  url "https://github.com/nfc-tools/mfcuk/archive/mfcuk-0.3.8.tar.gz"
  sha256 "c7091d1a16b132e1a4917ebc705065b60f3d1a0b449a776411ba39612a62ee89"

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "libusb"

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
