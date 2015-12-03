class Ntopng < Formula
  desc "Next generation version of the original ntop"
  homepage "http://www.ntop.org/products/ntop/"
  url "https://downloads.sourceforge.net/project/ntop/ntopng/ntopng-2.2.tar.gz"
  sha256 "4fccfc9e9f333addcd3c957b4520c471117bc2df5655d6eabf328c7385fb255e"

  bottle do
    sha256 "e980bd3474e6ed3cf845e75e6ad5f7eabe9b30ed97ad3f3ddd0415a76b19f855" => :el_capitan
    sha256 "7c99927ee3e313844d2f615bcf4632390a2328cb761384ae09410d14fe241edc" => :yosemite
    sha256 "e6034a1029f47b440f7dd39c1ec41ab4b9e20cb5babae518456f3d1420d219e7" => :mavericks
  end

  head do
    url "https://github.com/ntop/ntopng.git", :branch => "dev"

    resource "nDPI" do
      url "https://github.com/ntop/nDPI.git", :branch => "dev"
    end
  end

  option "with-mariadb", "Build with mariadb support"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build
  depends_on "json-glib" => :build
  depends_on "wget" => :build
  depends_on "zeromq" => :build
  depends_on "gnutls" => :build

  depends_on "json-c"
  depends_on "rrdtool"
  depends_on "luajit"
  depends_on "geoip"
  depends_on "redis"
  depends_on "mysql" if build.without? "mariadb"
  depends_on "mariadb" => :optional

  def install
    if build.head?
      resource("nDPI").stage do
        system "./autogen.sh"
        system "make"
        (buildpath/"nDPI").install Dir["*"]
      end
    end
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ntopng", "-h"
  end
end
