class GsettingsDesktopSchemas < Formula
  desc "GSettings schemas for desktop components"
  homepage "https://download.gnome.org/sources/gsettings-desktop-schemas/"
  url "https://download.gnome.org/sources/gsettings-desktop-schemas/3.20/gsettings-desktop-schemas-3.20.0.tar.xz"
  sha256 "55a41b533c0ab955e0a36a84d73829451c88b027d8d719955d8f695c35c6d9c1"

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
