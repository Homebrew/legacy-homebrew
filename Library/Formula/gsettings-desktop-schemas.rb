class GsettingsDesktopSchemas < Formula
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.14/gsettings-desktop-schemas-3.14.0.tar.xz"
  sha256 "cf3ba58f6257155080b1872b4a6ce4a2424bb7af3f08e607b428cb47b065f2d7"

  bottle do
    revision 2
    sha256 "ed713e36bb658c3ac715a43ac505389a427f06540e47a2521f7291875ac1d4fa" => :yosemite
    sha256 "45e1e8d292bd2356cfcbc7090fb189536c974f73881cef20f2fdb40c6c6c013c" => :mavericks
    sha256 "b1820bdd931682580c900920d0cf1edb4c1a0d86755dbb6dd310f5552f72879a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib"
  depends_on "gobject-introspection" => :build
  depends_on "gettext"
  depends_on "libffi"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-schemas-compile",
                          "--enable-introspection=yes"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <gdesktop-enums.h>

      int main(int argc, char *argv[]) {
        return 0;
      }
    EOS
    system ENV.cc, "-I#{HOMEBREW_PREFIX}/include/gsettings-desktop-schemas", "test.c", "-o", "test"
    system "./test"
  end

  def post_install
    # manual schema compile step
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
  end
end
