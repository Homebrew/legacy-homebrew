class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.2/graphene-1.2.6.tar.xz"
  sha256 "987a83be0b9e634805d8bb949d11422a42e627fd40f78c68c3b1ac7b3243cda2"

  bottle do
    cellar :any
    sha256 "5c1242c087ac5940a65f5206753b2257b1e7a7527bb243f539ccdbe26df91a76" => :yosemite
    sha256 "ba71259f21f30ffc272dae108d1cad4993b3207ccf7b48202feb07d9dedd2d0e" => :mavericks
    sha256 "41aca31352fe31cb7efe693e897652ccef7b34b6ccb3bad9192b864a5bbc7337" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

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
