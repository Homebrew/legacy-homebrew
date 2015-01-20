class GdkPixbuf < Formula
  homepage "http://gtk.org"
  url "http://ftp.gnome.org/pub/GNOME/sources/gdk-pixbuf/2.31/gdk-pixbuf-2.31.2.tar.xz"
  sha256 "9e467ed09894c802499fb2399cd9a89ed21c81700ce8f27f970a833efb1e47aa"

  bottle do
    sha1 "4f6b7b2f3324001230f13875d1549e4b81e31b0c" => :yosemite
    sha1 "f365fe6ac4a8adbf1a474c0864fe6faf920e995a" => :mavericks
    sha1 "0e0e7d4baa212b6cdf699e2273937d9a89d979e8" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libpng"
  depends_on "gobject-introspection"

  # "loaders.cache" must be writable by other packages
  skip_clean "lib/gdk-pixbuf-2.0"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-maintainer-mode",
                          "--enable-debug=no",
                          "--prefix=#{prefix}",
                          "--enable-introspection=yes",
                          "--disable-Bsymbolic",
                          "--without-gdiplus"
    system "make"
    system "make", "install"

    # Other packages should use the top-level modules directory
    # rather than dumping their files into the gdk-pixbuf keg.
    inreplace lib/"pkgconfig/gdk-pixbuf-2.0.pc" do |s|
      libv = s.get_make_var "gdk_pixbuf_binary_version"
      s.change_make_var! "gdk_pixbuf_binarydir",
        HOMEBREW_PREFIX/"lib/gdk-pixbuf-2.0"/libv
    end
  end

  def post_install
    # Change the version directory below with any future update
    ENV["GDK_PIXBUF_MODULEDIR"]="#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    system "#{bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end

  def caveats; <<-EOS.undent
    Programs that require this module need to set the environment variable
      export GDK_PIXBUF_MODULEDIR="#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    If you need to manually update the query loader cache, set GDK_PIXBUF_MODULEDIR then run
      #{bin}/gdk-pixbuf-query-loaders --update-cache
    EOS
  end

  test do
    system "#{bin}/gdk-pixbuf-pixdata", "-h"
  end
end
