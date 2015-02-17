class Libdvdnav < Formula
  homepage "https://dvdnav.mplayerhq.hu/"
  url "https://download.videolan.org/pub/videolan/libdvdnav/5.0.3/libdvdnav-5.0.3.tar.bz2"
  sha256 "5097023e3d2b36944c763f1df707ee06b19dc639b2b68fb30113a5f2cbf60b6d"

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
