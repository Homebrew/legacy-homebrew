require "formula"

class Libdvdnav < Formula
  homepage "https://dvdnav.mplayerhq.hu/"
  url "http://download.videolan.org/pub/videolan/libdvdnav/5.0.1/libdvdnav-5.0.1.tar.bz2"
  sha256 "72b1cb8266f163d4a1481b92c7b6c53e6dc9274d2a6befb08ffc351fe7a4a2a9"

  head do
    url "git://git.videolan.org/libdvdnav.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    revision 1
    sha1 "8c2db56f7b72fb9dc3ab3c671895f849d6afd686" => :yosemite
    sha1 "6719c51ec9f3d7746cc23996603ab7e66ea739c7" => :mavericks
    sha1 "7a08652f39426feefc93525ecb6aceab4d3aa720" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libdvdread"

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
