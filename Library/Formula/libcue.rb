class Libcue < Formula
  desc "Cue sheet parser library for C"
  homepage "https://github.com/lipnitsk/libcue"
  url "https://github.com/lipnitsk/libcue/archive/v1.4.0.tar.gz"
  sha256 "c3c46d58cebf15b3fe07e6f649014694d338ddd880e941bfb1fd3cedae66c62f"

  bottle do
    cellar :any
    revision 1
    sha256 "cc35f80989bb79d69fe7eb1e2c467961fa80e56318311bcf079f35626b14ac84" => :el_capitan
    sha1 "4f77185f22c3099fe9f310494dedb9ac7913be77" => :yosemite
    sha1 "16e526dbe49a96dd8c9bd688b31195d756dd7bf0" => :mavericks
    sha1 "baa3227a1734763ba21355a6e403b81a205919d2" => :mountain_lion
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
