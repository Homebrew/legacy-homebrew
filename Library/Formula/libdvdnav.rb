class Libdvdnav < Formula
  desc "DVD navigation library"
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
    sha256 "55cc5f7787e261ac4fd35e3a074b8c4c85b9f286f9a5badcb4a2b2cadcaaaf99" => :yosemite
    sha256 "c1e5cad22c6ed634ebf70c67a5dc2ed2d5c57874d5ef5253f6161eeea93bdc07" => :mavericks
    sha256 "39022ccc0b5f21530e4ebbccc6c4964d53b39108c56d8f8e0d4b59587cddb506" => :mountain_lion
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
