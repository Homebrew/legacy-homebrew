class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://propublica.github.io/simple-tiles/"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.0.tar.gz"
  sha256 "336fdc04c34b85270c377d880a0d4cc2ac1a9c9e5e4c3d53e0322d43c9495ac9"
  revision 2

  head "https://github.com/propublica/simple-tiles.git"

  bottle do
    cellar :any
    sha256 "3ccf8630a6b5e3753094068e99e3eb9ce3759ab2096f9d25c7f01c435352bf4c" => :el_capitan
    sha256 "26f1181169e02bc307686b1b16c287d4f18ba3296ec1743edfeab80f722dcf09" => :yosemite
    sha256 "bae1c5f45992d4d4b096b2056b44a843026f3998ad35403c12e5eb4235601c7a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdal"
  depends_on "pango"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <simple-tiles/simple_tiles.h>

      int main(){
        simplet_map_t *map = simplet_map_new();
        simplet_map_free(map);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lsimple-tiles",
           "-I#{Formula["cairo"].opt_include}/cairo",
           "-I#{Formula["gdal"].opt_include}",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-I#{Formula["pango"].opt_include}/pango-1.0",
           "test.c", "-o", "test"
    system testpath/"test"
  end
end
