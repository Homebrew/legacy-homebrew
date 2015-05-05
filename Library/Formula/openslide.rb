class Openslide < Formula
  homepage "http://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v3.4.1/openslide-3.4.1.tar.xz"
  sha256 "9938034dba7f48fadc90a2cdf8cfe94c5613b04098d1348a5ff19da95b990564"

  bottle do
    cellar :any
    sha1 "f03b2209cd35a2b548b012210ea2e439c80b44d7" => :yosemite
    sha1 "5327cde1c873328b6b90f48a8400b569436323de" => :mavericks
    sha1 "ef49c02614e0ec8c2a0e5f71a6de309023a77a0c" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "jpeg"
  depends_on "libxml2"
  depends_on "libtiff"
  depends_on "glib"
  depends_on "openjpeg"
  depends_on "cairo"
  depends_on "gdk-pixbuf"

  resource "svs" do
    url "http://openslide.cs.cmu.edu/download/openslide-testdata/Aperio/CMU-1-Small-Region.svs"
    sha256 "ed92d5a9f2e86df67640d6f92ce3e231419ce127131697fbbce42ad5e002c8a7"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    resource("svs").stage do
      system bin/"openslide-show-properties", "CMU-1-Small-Region.svs"
    end
  end
end
