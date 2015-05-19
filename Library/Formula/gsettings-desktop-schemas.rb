class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.16/gsettings-desktop-schemas-3.16.1.tar.xz"
  sha256 "74fe9fdad510c8a6666febeceb7ebafc581ef990b3afcc8c1e8b5d90b24b3461"

  bottle do
    sha256 "02a5ea7cdd9874437e86a908e21dd7edb7cd8972dbca153bfce94789bd805a47" => :yosemite
    sha256 "b4cb92f15b7efe4054c4cebfca02010d74f71707ff1e099a495924b664124664" => :mavericks
    sha256 "acfda30db7e04df28bc38f12e368810c9592a06e29911d2e84fc60ee51a40ca3" => :mountain_lion
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
