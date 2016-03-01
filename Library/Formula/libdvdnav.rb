class Libdvdnav < Formula
  desc "DVD navigation library"
  homepage "https://dvdnav.mplayerhq.hu/"
  url "https://download.videolan.org/pub/videolan/libdvdnav/5.0.3/libdvdnav-5.0.3.tar.bz2"
  sha256 "5097023e3d2b36944c763f1df707ee06b19dc639b2b68fb30113a5f2cbf60b6d"

  bottle do
    cellar :any
    revision 1
    sha256 "c154d3b9579441836cac120264fcc61212347fdb39c9e52a95d22bb10bd5ec59" => :el_capitan
    sha256 "eba1770d502af4fb840ed14fd26e0da38641b1a4d6f7dbe04388fe57e17cf8e2" => :yosemite
    sha256 "c808f52803ee2b8d9644121d9d5a6016e4974cc91d4be54422d7c46be7276031" => :mavericks
  end

  head do
    url "https://git.videolan.org/git/libdvdnav.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
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
