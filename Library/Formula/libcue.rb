class Libcue < Formula
  desc "Cue sheet parser library for C"
  homepage "https://github.com/lipnitsk/libcue"
  url "https://github.com/lipnitsk/libcue/archive/v1.4.0.tar.gz"
  sha256 "c3c46d58cebf15b3fe07e6f649014694d338ddd880e941bfb1fd3cedae66c62f"

  bottle do
    cellar :any
    revision 2
    sha256 "420574b32e8adcca07f13a7727b4f2d3391b91566aa7fad63b452cd11fc881ad" => :el_capitan
    sha256 "1734b330e87a099d8a0c472af86e3f1c1babfabb3d29240a74e54e98932c91af" => :yosemite
    sha256 "f61624f74ef918f2b90bdfc9157f7a08829153dd2655ad73126e0a0ddd60127d" => :mavericks
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build

  def install
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
