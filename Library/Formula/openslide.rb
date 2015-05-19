class Openslide < Formula
  desc "C library to read whole-slide images (a.k.a. virtual slides)"
  homepage "http://openslide.org/"
  url "https://github.com/openslide/openslide/releases/download/v3.4.1/openslide-3.4.1.tar.xz"
  sha256 "9938034dba7f48fadc90a2cdf8cfe94c5613b04098d1348a5ff19da95b990564"

  bottle do
    cellar :any
    sha256 "1441f58796407e0b778b44aaaa13e20681703c0ad523d82b73c4318a6f32ad3b" => :yosemite
    sha256 "5f03cede5654c996a15818d6b15a4e567183481741db01d84a8697e114e1bd34" => :mavericks
    sha256 "f0e4ca9856f91a6b7a98195a50d1f3d32dc98d47125f54eef179f9f3c2ba3a14" => :mountain_lion
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
