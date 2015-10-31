class Libgdiplus < Formula
  desc "C-based implementation of the GDI+ API for Mono"
  homepage "http://www.mono-project.com/docs/gui/libgdiplus/"
  url "https://github.com/mono/libgdiplus/tarball/3b284ab28cb8737f9d14dabfedc6903655c66a7f"
  head "https://github.com/mono/libgdiplus.git"
  sha256 "c7b6e68f4f4ef62e1f7551769c7f0b87e7debd52311123a0264d23cf7ac9aee8"
  version "3.12" # latest tag = 3.12, plus two patches.

  # it depends on mono to link to System.Drawing
  depends_on "libexif"
  depends_on "glib"
  depends_on "cairo"
  depends_on :x11 => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  # And it depends on mono to build, but this formula is specified as a resource
  # in that recipe.

  def install
    system "CPPFLAGS=-I/opt/X11/include ./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "true"
  end
end
