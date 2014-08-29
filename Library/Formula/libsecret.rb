require "formula"

class Libsecret < Formula
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "http://ftp.gnome.org/pub/gnome/sources/libsecret/0.18/libsecret-0.18.tar.xz"
  sha1 "af62de3958bbe0ccf59a02101a6704e036378a6f"

  bottle do
    revision 1
    sha1 "d66a78d9886a1c3264efc8837f76be38b5f537a5" => :mavericks
    sha1 "413b3bc851bc3c9cdc1e9a8f0d325ad974f97fcc" => :mountain_lion
    sha1 "d2118e640acacfc9028e9d4e9b4f90149d560e10" => :lion
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
