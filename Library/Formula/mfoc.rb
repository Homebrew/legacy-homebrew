class Mfoc < Formula
  desc "Implementation of 'offline nested' attack by Nethemba"
  homepage "https://github.com/nfc-tools/mfoc"
  url "https://github.com/nfc-tools/mfoc/archive/mfoc-0.10.7.tar.gz"
  sha256 "2dfd8ffa4a8b357807680d190a91c8cf3db54b4211a781edc1108af401dbaad7"

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
