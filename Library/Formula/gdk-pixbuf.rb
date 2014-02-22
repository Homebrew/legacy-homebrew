require 'formula'

class GdkPixbuf < Formula
  homepage 'http://gtk.org'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gdk-pixbuf/2.30/gdk-pixbuf-2.30.4.tar.xz'
  sha256 'a13bbad0d804829b260bc901dc7d284d330c534489fc1666c126fa4555bbb051'

  bottle do
    sha1 "5e264d248d4893087f1e8bcc044b6977f552032f" => :mavericks
    sha1 "08fe8e370c69bda4b2fabbbc6a2817fcd24545d9" => :mountain_lion
    sha1 "9bb3a41fc00a096cec2bce041729c59e74bdd617" => :lion
  end

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'glib'
  depends_on 'jpeg'
  depends_on 'libtiff'
  depends_on :libpng
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
