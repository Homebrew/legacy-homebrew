class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "http://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.32/gdk-pixbuf-2.32.3.tar.xz"
  sha256 "2b6771f1ac72f687a8971e59810b8dc658e65e7d3086bd2e676e618fd541d031"

  bottle do
    sha256 "eb8c35bdc91653f7e10b48d2933ff2012027f1495b26b3290887993adb1c02aa" => :el_capitan
    sha256 "f9a0c8f025b0a7365440e8e28152087285026ab26df0b3de33aa7b45588e0254" => :yosemite
    sha256 "00f0d5386d69dbd87fcd2ef6e84a8f57e5cea354abcc307dec0b3c684593c31c" => :mavericks
  end

  option :universal
  option "with-relocations", "Build with relocation support for bundles"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libpng"
  depends_on "gobject-introspection"

  # 'loaders.cache' must be writable by other packages
  skip_clean "lib/gdk-pixbuf-2.0"

  def install
    ENV.universal_binary if build.universal?
    ENV.append_to_cflags "-DGDK_PIXBUF_LIBDIR=\\\"#{HOMEBREW_PREFIX}/lib\\\""
    args = ["--disable-dependency-tracking",
            "--disable-maintainer-mode",
            "--enable-debug=no",
            "--prefix=#{prefix}",
            "--enable-introspection=yes",
            "--disable-Bsymbolic",
            "--enable-static",
            "--without-gdiplus",]

    args << "--enable-relocations" if build.with?("relocations")

    system "./configure", *args
    system "make"
    system "make", "install"

    # Other packages should use the top-level modules directory
    # rather than dumping their files into the gdk-pixbuf keg.
    inreplace lib/"pkgconfig/gdk-pixbuf-2.0.pc" do |s|
      libv = s.get_make_var "gdk_pixbuf_binary_version"
      s.change_make_var! "gdk_pixbuf_binarydir",
        HOMEBREW_PREFIX/"lib/gdk-pixbuf-2.0"/libv
    end

    # Remove the cache. We will regenerate it in post_install
    (lib/"gdk-pixbuf-2.0/2.10.0/loaders.cache").unlink
  end

  def post_install
    # Change the version directory below with any future update
    if build.with?("relocations")
      ENV["GDK_PIXBUF_MODULE_FILE"]="#{lib}/gdk-pixbuf-2.0/2.10.0/loaders.cache"
      ENV["GDK_PIXBUF_MODULEDIR"]="#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    end
    system "#{bin}/gdk-pixbuf-query-loaders", "--update-cache"
  end

  def caveats; <<-EOS.undent
    Programs that require this module need to set the environment variable
      export GDK_PIXBUF_MODULE_FILE="#{lib}/gdk-pixbuf-2.0/2.10.0/loaders.cache"
      export GDK_PIXBUF_MODULEDIR="#{HOMEBREW_PREFIX}/lib/gdk-pixbuf-2.0/2.10.0/loaders"
    If you need to manually update the query loader cache, set these variables then run
      #{bin}/gdk-pixbuf-query-loaders --update-cache
    EOS
  end if build.with?("relocations")

  test do
    system bin/"gdk-pixbuf-csource", test_fixtures("test.png")
  end
end
