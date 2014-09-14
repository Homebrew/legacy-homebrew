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
    sha1 "fdd2a4d4e292054b0822723e6577d91fd1744d91" => :mavericks
    sha1 "ff19d811cabb6338ebeecf1f91dea1a9347349c3" => :mountain_lion
    sha1 "3e0fa252e8862a0374e5e53ddf6feefa1172d5f7" => :lion
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
