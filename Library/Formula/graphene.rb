class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.2/graphene-1.2.10.tar.xz"
  sha256 "e7b58334a91ae75b776fda987c29867710008673040fc996949933f2c5f17fdb"

  bottle do
    sha256 "c696932d3e1fc77275461425ecc10fa033431886ece6096514ae2a5b9517e219" => :yosemite
    sha256 "83e30e2146e87c91cde184aeba27189ce8e351d52c235d7bf49175969af6842e" => :mavericks
    sha256 "b6a2a3830280fafc04e8b5de5ec8301cec6409e2021504959f7e048d69b5b5d8" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <graphene-gobject.h>

      int main(int argc, char *argv[]) {
      GType type = graphene_point_get_type();
        return 0;
      }
    EOS
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/graphene-1.0
      -I#{lib}/graphene-1.0/include
      -L#{lib}
      -lgraphene-1.0
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
