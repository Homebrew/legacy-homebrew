class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://propublica.github.io/simple-tiles/"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.0.tar.gz"
  sha256 "336fdc04c34b85270c377d880a0d4cc2ac1a9c9e5e4c3d53e0322d43c9495ac9"
  revision 1

  head "https://github.com/propublica/simple-tiles.git"

  bottle do
    cellar :any
    sha256 "feaaac49a14352c65dc4163fcfb483e220a3015edbe9671d68b42f08e04ce255" => :yosemite
    sha256 "46e57be573ad461719de4df03e352308cd657658472436b7b0bc8303c85e75b2" => :mavericks
    sha256 "875ae1cc1fe6bdf01504dbbee45bc14079c394680be55aaea41c3b9d4ccec487" => :mountain_lion
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
