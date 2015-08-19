class Mfcuk < Formula
  desc "MiFare Classic Universal toolKit"
  homepage "https://code.google.com/p/mfcuk/"
  url "https://mfcuk.googlecode.com/files/mfcuk-0.3.8.tar.gz"
  sha256 "977595765b4b46e4f47817e9500703aaf5c1bcad39cb02661f862f9d83f13a55"

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
