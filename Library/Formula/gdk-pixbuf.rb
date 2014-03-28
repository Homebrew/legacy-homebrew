require 'formula'

class GdkPixbuf < Formula
  homepage 'http://gtk.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gdk-pixbuf/2.30/gdk-pixbuf-2.30.7.tar.xz'
  sha256 '0aafc365eab1083a53f15e4828333b968219ffcb1a995ac6289c0147c9ffad06'

  bottle do
    sha1 "8e76502fdd8ef8152d8605e36b0ee5ddd68d674c" => :mavericks
    sha1 "65f7be7d03ca6068f07cafc4e734c8565dd680d6" => :mountain_lion
    sha1 "97159c6b2f3f28463fb255cebd443fb50abac974" => :lion
  end

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on 'libpng'
  depends_on 'gobject-introspection'

  # 'loaders.cache' must be writable by other packages
  skip_clean 'lib/gdk-pixbuf-2.0'

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
    system "make install"

    # Other packages should use the top-level modules directory
    # rather than dumping their files into the gdk-pixbuf keg.
    inreplace lib/'pkgconfig/gdk-pixbuf-2.0.pc' do |s|
      libv = s.get_make_var 'gdk_pixbuf_binary_version'
      s.change_make_var! 'gdk_pixbuf_binarydir',
        HOMEBREW_PREFIX/'lib/gdk-pixbuf-2.0'/libv
    end
  end
end
