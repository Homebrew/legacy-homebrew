require "formula"

class Libsecret < Formula
  desc "Library for storing/retrieving passwords and other secrets"
  homepage "https://wiki.gnome.org/Projects/Libsecret"
  url "http://ftp.gnome.org/pub/gnome/sources/libsecret/0.18/libsecret-0.18.tar.xz"
  sha1 "af62de3958bbe0ccf59a02101a6704e036378a6f"

  bottle do
    revision 2
    sha1 "6716e52cad2d6f84a0cf4a5211bb7cc4cd38dde8" => :yosemite
    sha1 "05bed826d27824dc9e0588126473bba2e2e31428" => :mavericks
    sha1 "aa373554171d40655dff546a66c4f45d372a04d7" => :mountain_lion
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
