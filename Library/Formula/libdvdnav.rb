require 'formula'

class Libdvdnav < Formula
  homepage 'http://dvdnav.mplayerhq.hu/'
  url 'http://dvdnav.mplayerhq.hu/releases/libdvdnav-4.2.1.tar.xz'
  sha256 '7fca272ecc3241b6de41bbbf7ac9a303ba25cb9e0c82aa23901d3104887f2372'

  head 'git://git.videolan.org/libdvdnav.git'

  bottle do
    cellar :any
    sha1 "fdd2a4d4e292054b0822723e6577d91fd1744d91" => :mavericks
    sha1 "ff19d811cabb6338ebeecf1f91dea1a9347349c3" => :mountain_lion
    sha1 "3e0fa252e8862a0374e5e53ddf6feefa1172d5f7" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libdvdread"

  def install
    system "./autogen.sh", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
