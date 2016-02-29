class Mfoc < Formula
  desc "Implementation of 'offline nested' attack by Nethemba"
  homepage "https://github.com/nfc-tools/mfoc"
  url "https://github.com/nfc-tools/mfoc/archive/mfoc-0.10.7.tar.gz"
  sha256 "2DFD8FFA4A8B357807680D190A91C8CF3DB54B4211A781EDC1108AF401DBAAD7"

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
    system bin/"mfoc", "-h"
  end
end
