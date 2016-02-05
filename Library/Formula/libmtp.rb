class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "http://libmtp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.10/libmtp-1.1.10.tar.gz"
  sha256 "1eee8d4c052fe29e58a408fedc08a532e28626fa3e232157abd8fca063c90305"

  bottle do
    cellar :any
    sha256 "f1aef2931e982752ef4fd41a5be2d22fd7ee59004692dfbb62ed378b85b8059d" => :el_capitan
    sha256 "b7f92f9c8f9ba818bf8b3913ac00f8502b43cedad27af6396daecb2c73d5637e" => :yosemite
    sha256 "0e0da0a291315f2ac64fa3592f6fe477433e7e5ef97258016b7e870a418cdc7c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz"
    system "make", "install"
  end
end
