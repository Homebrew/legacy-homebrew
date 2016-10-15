require "formula"

class Gimp < Formula
  homepage "http://www.gimp.org"
  url "http://download.gimp.org/pub/gimp/v2.8/gimp-2.8.14.tar.bz2"
  sha1 "380a8e2887e1a161056444921807e338c3d31653"
  head "https://github.com/GNOME/gimp.git", :branch => "gimp-2-8"

  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build

  depends_on :x11 => :recommended

  depends_on "gegl"
  depends_on "babl"
  depends_on "fontconfig"

  if build.with? "x11"
    depends_on "pango"
    depends_on "gtk+"
    depends_on "cairo"
    depends_on "pygtk"
  else
    depends_on "pango" => "without-x11"
    depends_on "gtk+" => "without-x11"
    depends_on "cairo" => "without-x11"
    depends_on "pygtk" => "without-x11"
  end

  depends_on "glib"
  depends_on "gdk-pixbuf"
  depends_on "freetype"
  depends_on "xz"
  depends_on "lbzip2"
  depends_on "aalib"
  depends_on "ghostscript"
  depends_on "libpng"
  depends_on "librsvg"
  depends_on "libwmf"
  depends_on "libexif"
  depends_on "d-bus"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-glibtest"
    system "make", "install"
  end

  test do
    system "#{bin}/gimp", "--version"
  end
end
