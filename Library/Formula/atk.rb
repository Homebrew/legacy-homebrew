class Atk < Formula
  homepage "https://library.gnome.org/devel/atk/"
  url "http://ftp.gnome.org/pub/gnome/sources/atk/2.16/atk-2.16.0.tar.xz"
  sha256 "095f986060a6a0b22eb15eef84ae9f14a1cf8082488faa6886d94c37438ae562"

  bottle do
    revision 1
    sha1 "5a014bce43ff14675bec23b61909d3d85cff20f1" => :yosemite
    sha1 "f75b7b55547cb58c87fd35e38e8cdba0877516f8" => :mavericks
    sha1 "8aa05a84f58854ba26258d0d206c4e2fb663eb16" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gobject-introspection"

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes"
    system "make"
    system "make", "install"
  end
  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <atk/atk.h>

      int main(int argc, char *argv[]) {
        const gchar *version = atk_get_version();
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/atk-1.0", "-I#{HOMEBREW_PREFIX}/include/glib-2.0", "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include", "-I#{HOMEBREW_PREFIX}/opt/gettext/include", "test.c", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/lib", "-L#{HOMEBREW_PREFIX}/opt/gettext/lib", "-latk-1.0", "-lgobject-2.0", "-lglib-2.0", "-lintl", "-o", "test"
    system "./test"
  end
end
