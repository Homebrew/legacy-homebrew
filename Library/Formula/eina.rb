class Eina < Formula
  desc "Core data structure and common utility library for Enlightenment"
  homepage "https://docs.enlightenment.org/auto/eina/eina_main.html"
  url "https://download.enlightenment.org/releases/eina-1.7.10.tar.gz"
  sha256 "3f33ae45c927faedf8d342106136ef1269cf8dde6648c8165ce55e72341146e9"

  head do
    url "https://git.enlightenment.org/legacy/eina.git/"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle :disable, "Work around broken pkgconfig in bottle installation (#45293)"

  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
