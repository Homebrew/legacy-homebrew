class Librsvg < Formula
  homepage "https://live.gnome.org/LibRsvg"
  url "https://download.gnome.org/sources/librsvg/2.40/librsvg-2.40.5.tar.xz"
  sha256 "d14d7b3e25023ce34302022fd7c9b3a468629c94dff6c177874629686bfc71a7"

  bottle do
    sha256 "f7ca7f815635467444ffeb8b2ec27411ed565ecbd7e6761bee033b2b26b531d8" => :yosemite
    sha256 "e2f61ce1337fc727fdc7e895efe18f8f70ab7a698e8e0f51bddacfbf4be01dfd" => :mavericks
    sha256 "239c9ab0823ab139828e0140c1cdfd6f2e1c536d0478a225d1db489d6b80981a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gtk+" => :recommended
  depends_on "gtk+3" => :optional
  depends_on "libcroco"
  depends_on "libgsf" => :optional
  depends_on "pango"
  depends_on :x11 => :recommended

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--disable-Bsymbolic",
            "--enable-tools=yes",
            "--enable-pixbuf-loader=yes",
            "--enable-introspection=yes"]

    args << "--enable-svgz" if build.with? "libgsf"

    system "./configure", *args
    system "make", "install",
      "gdk_pixbuf_binarydir=#{lib}/gdk-pixbuf-2.0/2.10.0/loaders",
      "gdk_pixbuf_moduledir=#{lib}/gdk-pixbuf-2.0/2.10.0/loaders"
  end

  def post_install
    # librsvg is not aware GDK_PIXBUF_MODULEDIR must be set
    # set GDK_PIXBUF_MODULEDIR and update loader cache
    ENV["GDK_PIXBUF_MODULEDIR"] = "#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    system "#{Formula["gdk-pixbuf"].opt_bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end
end
