class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.18/gsettings-desktop-schemas-3.18.0.tar.xz"
  sha256 "ba27337226a96d83f385c0ad192fdfe561c7e7882c61bb326c571be24e41eceb"

  bottle do
    cellar :any_skip_relocation
    sha256 "11b19039bd89c2f8c91c9843f7aa359d760ba0fa4e49e4bd45bca0698458c662" => :el_capitan
    sha256 "20d7eb21f495fa5f2def713fbf5cac516273f8c178c3fd1a1ba1abad894fa63e" => :yosemite
    sha256 "3e8acc9cc698653044aa55f7f3d662cfa133487190338c8948229094774d7729" => :mavericks
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
