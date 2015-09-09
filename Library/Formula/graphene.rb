class Graphene < Formula
  desc "Thin layer of graphic data types"
  homepage "https://ebassi.github.io/graphene/"
  url "https://download.gnome.org/sources/graphene/1.2/graphene-1.2.6.tar.xz"
  sha256 "987a83be0b9e634805d8bb949d11422a42e627fd40f78c68c3b1ac7b3243cda2"

  bottle do
    revision 1
    sha256 "1dbcc5c38fdb48ace59ad4f6af0be6afedac94ae4734a551479195c79386c46f" => :yosemite
    sha256 "80fcf20bdbfda56a510b3c24e70bc22848d1268008a9c39683ced8b358430098" => :mavericks
    sha256 "597b9d3cf2414166089f60753131cfc24c308328bd6b4b6518d78f577b51fcb5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  # this next line is necessary because the build system relies on sed pattern GNU extensions.
  # should be fixed in the next release of graphene.
  # reported upstream as https://github.com/ebassi/graphene/issues/42
  depends_on "gnu-sed" => :build
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
