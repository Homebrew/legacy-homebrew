class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.18/gsettings-desktop-schemas-3.18.1.tar.xz"
  sha256 "258713b2a3dc6b6590971bcfc81f98d78ea9827d60e2f55ffbe40d9cd0f99a1a"

  bottle do
    cellar :any_skip_relocation
    sha256 "a690c0ea4800545e96753020eed7c1e81751a93320f79d12e37fc75d4907e8d6" => :el_capitan
    sha256 "a4a787a33ec4b84eaa6fce08fea0c81bbef4babb59534fcdf94eec76b9a1ac4a" => :yosemite
    sha256 "ce52e45a24271c8515eccabc0ed99fa0d83d54c06c65b408140d52891afcf978" => :mavericks
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
