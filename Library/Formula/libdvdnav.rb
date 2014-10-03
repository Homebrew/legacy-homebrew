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
    sha1 "1c8497e91b304e268351978ba6db2f4c2ee5444f" => :mavericks
    sha1 "230adf7b5bad4c6da42e194ae8c39cc54122f6ae" => :mountain_lion
    sha1 "34f7a905801938f76f356a20e0e9625052b53582" => :lion
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
