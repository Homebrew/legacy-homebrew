class Gimp < Formula
  desc "GNU Image Manipulation Program"
  homepage "http://www.gimp.org"

  stable do
    url "http://download.gimp.org/pub/gimp/v2.8/gimp-2.8.16.tar.bz2"
    sha256 "95e3857bd0b5162cf8d1eda8c78b741eef968c3e3ac6c1195aaac2a4e2574fb7"
    depends_on "homebrew/versions/gegl02"
  end

  bottle do
    sha256 "8021bf2728b7189d2922cca68a40f53773e4d079053fc3357bc1750cf9875c8c" => :yosemite
    sha256 "52a2938d2e67222d7f6ff972dfc8715e68d5e505b80d4b9e5ce3fc70668d74da" => :mavericks
    sha256 "29551de7ab55f5ecdec2b19edc9c9a329b10160eaca25fc1368bb0824aaeda7c" => :mountain_lion
  end

  head do
    url "https://github.com/GNOME/gimp.git", :branch => "gimp-2-8"
    depends_on "gegl"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "babl"
  depends_on "fontconfig"
  depends_on "pango"
  depends_on "gtk+"
  depends_on "gtk-mac-integration"
  depends_on "cairo"
  depends_on "pygtk"
  depends_on "glib"
  depends_on "gdk-pixbuf"
  depends_on "freetype"
  depends_on "xz" # For LZMA
  depends_on "d-bus"
  depends_on "aalib"
  depends_on "librsvg"
  depends_on "libpng" => :recommended
  depends_on "libwmf" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "ghostscript" => :optional
  depends_on "poppler" => :optional
  depends_on "libexif" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-glibtest
      --disable-gtktest
      --datarootdir=#{share}
      --sysconfdir=#{etc}
      --without-x
    ]

    args << "--without-libtiff" if build.without? "libtiff"
    args << "--without-libpng" if build.without? "libpng"
    args << "--without-wmf" if build.without? "libwmf"
    args << "--without-poppler" if build.without? "poppler"
    args << "--without-libexif" if build.without? "libexif"

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/gimp", "--version"
  end
end
