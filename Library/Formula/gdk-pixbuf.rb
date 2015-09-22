class GdkPixbuf < Formula
  desc "Toolkit for image loading and pixel buffer manipulation"
  homepage "http://gtk.org"
  url "https://download.gnome.org/sources/gdk-pixbuf/2.32/gdk-pixbuf-2.32.0.tar.xz"
  sha256 "537655ec3635740e949457bafe61ae44ce0e5642a2529a9ef7ee0bcd5e911b67"

  bottle do
    revision 1
    sha256 "c7d8bc0380bb1116c2d0ce743e56daa59e982b95ce321076409d24eb960124fa" => :el_capitan
    sha1 "fb4261dd767c0e88888ef210e7c6bf91c4e2549e" => :yosemite
    sha1 "06dc916f0fc6018e390285cb4b882478b10417fd" => :mavericks
    sha1 "b3e286bf4e15e8e2e522f049c8e8d9a39c5b4f36" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "jpeg"
  depends_on "libtiff"
  depends_on "libpng"
  depends_on "gobject-introspection"

  # disable the default relocatable library setting
  patch :DATA

  # 'loaders.cache' must be writable by other packages
  skip_clean "lib/gdk-pixbuf-2.0"

  def install
    ENV.universal_binary if build.universal?
    ENV.append_to_cflags "-DGDK_PIXBUF_LIBDIR=\\\"#{HOMEBREW_PREFIX}/lib\\\""
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

    # Remove the cache. We will regenerate it in post_install
    (lib/"gdk-pixbuf-2.0/2.10.0/loaders.cache").unlink
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
    system bin/"gdk-pixbuf-csource", test_fixtures("test.png")
  end
end

__END__
diff --git a/configure b/configure
index ca603b8..2a8d073 100755
--- a/configure
+++ b/configure
@@ -20665,7 +20665,7 @@ esac

 if test "x$enable_relocations" = "xyes"; then

-$as_echo "#define GDK_PIXBUF_RELOCATABLE 1" >>confdefs.h
+$as_echo "#undef GDK_PIXBUF_RELOCATABLE" >>confdefs.h

 fi
