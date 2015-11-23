class Eina < Formula
  desc "Eina is a core data structure and common utility library"
  homepage "https://docs.enlightenment.org/auto/eina/eina_main.html"
  url "https://download.enlightenment.org/releases/eina-1.7.10.tar.gz"
  sha256 "3f33ae45c927faedf8d342106136ef1269cf8dde6648c8165ce55e72341146e9"

  bottle do
    sha1 "58d642bbf7088e75415c2d7267c1170e7bd99c39" => :yosemite
    sha1 "17da185c9c97ac84a55fb814a69171da1db77bbf" => :mavericks
    sha1 "1310e97405ab4ff2ab1160420ac8b0f4aa74cec7" => :mountain_lion
  end

  head do
    url "https://git.enlightenment.org/legacy/eina.git/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
