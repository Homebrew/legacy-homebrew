class Mfcuk < Formula
  desc "MiFare Classic Universal toolKit"
  homepage "https://github.com/nfc-tools/mfcuk"
  url "https://github.com/nfc-tools/mfcuk/archive/mfcuk-0.3.8.tar.gz"
  sha256 "C7091D1A16B132E1A4917EBC705065B60F3D1A0B449A776411BA39612A62EE89"

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
