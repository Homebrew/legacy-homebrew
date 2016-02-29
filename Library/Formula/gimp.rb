class Gimp < Formula
  desc "GNU Image Manipulation Program"
  homepage "https://www.gimp.org"

  stable do
    url "https://download.gimp.org/pub/gimp/v2.8/gimp-2.8.16.tar.bz2"
    sha256 "95e3857bd0b5162cf8d1eda8c78b741eef968c3e3ac6c1195aaac2a4e2574fb7"

    resource "gegl02" do
      url "https://download.gimp.org/pub/gegl/0.2/gegl-0.2.0.tar.bz2"
      sha256 "df2e6a0d9499afcbc4f9029c18d9d1e0dd5e8710a75e17c9b1d9a6480dd8d426"
    end
  end

  bottle do
    revision 2
    sha256 "62d2ecdca7b19379f9ca21c70d12d4fc4ac6e6ba99f14f43e09496f9cf92507c" => :el_capitan
    sha256 "67100a94031c36bf1e95b0f58bc756b00f507e3d05889c546c743b52f5055f14" => :yosemite
    sha256 "88c84b9a7bf6fe2ddbec6ec78c2d091c7b86c801799f57aa254ca93d0996f97d" => :mavericks
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
    if build.stable?
      resource("gegl02").stage do
        ENV.no_optimization if ENV.compiler == :llvm
        system "./configure", "--disable-debug", "--disable-dependency-tracking",
                              "--prefix=#{libexec}/gegl02", "--disable-docs"
        system "make", "install"
      end
      ENV.prepend_path "PATH", libexec/"gegl02/bin"
      ENV.prepend_path "PKG_CONFIG_PATH", libexec/"gegl02/lib/pkgconfig"
    end

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
