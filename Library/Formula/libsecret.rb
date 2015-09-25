class Libsecret < Formula
  desc "Library for storing/retrieving passwords and other secrets"
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "https://download.gnome.org/sources/libsecret/0.18/libsecret-0.18.3.tar.xz"
  sha256 "f2bf1d0c5ab4640664f3e3c7ef6b086c180e50ff415720b5e22f96750dbf84c9"

  bottle do
    sha256 "dadf181684aa4cde7b1b63aafd4a912b29c0a60b8948e42b2bfe363d156b89ed" => :yosemite
    sha256 "7d6cfd2b0ec29d4030174053717d1efde4908f2e652892a24886b653b46ed5fc" => :mavericks
    sha256 "0f84396333914ef681c2b26e0ace27fce72becdf647d15a2175fb63d7c36def6" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gnu-sed" => :build
  depends_on "intltool" => :build
  depends_on "gettext" => :build
  depends_on "vala" => :optional
  depends_on "gobject-introspection" => :recommended
  depends_on "glib"
  depends_on "libgcrypt"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
    ]

    args << "--enable-gobject-introspection" if build.with? "gobject-introspection"
    args << "--enable-vala" if build.with? "vala"

    system "./configure", *args

    # https://bugzilla.gnome.org/show_bug.cgi?id=734630
    inreplace "Makefile", "sed", "gsed"

    # https://bugzilla.gnome.org/show_bug.cgi?id=734631
    inreplace "Makefile", "--nonet", ""
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libsecret/secret.h>

      const SecretSchema * example_get_schema (void) G_GNUC_CONST;

      const SecretSchema *
      example_get_schema (void)
      {
          static const SecretSchema the_schema = {
              "org.example.Password", SECRET_SCHEMA_NONE,
              {
                  {  "number", SECRET_SCHEMA_ATTRIBUTE_INTEGER },
                  {  "string", SECRET_SCHEMA_ATTRIBUTE_STRING },
                  {  "even", SECRET_SCHEMA_ATTRIBUTE_BOOLEAN },
                  {  "NULL", 0 },
              }
          };
          return &the_schema;
      }

      int main()
      {
          example_get_schema();
      }
    EOS

    flags = [
      "-I#{include}/libsecret-1",
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include"
    ]

    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
