require 'formula'

class Vte < Formula
  homepage 'http://developer.gnome.org/vte/'
  url 'http://ftp.gnome.org/pub/gnome/sources/vte/0.28/vte-0.28.0.tar.bz2'
  sha1 '49b66a0346da09c72f59e5c544cc5b50e7de9bc1'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'gtk+'
  depends_on 'pygtk'

  def install
    # Detecting pygtk-2.0 fails without the PKG_CONFIG_PATH being set to
    # include some additional pkgconfig paths.
    ENV["PKG_CONFIG_PATH"] = "#{ENV["PKG_CONFIG_PATH"]}:/usr/local/lib/pkgconfig/:"
                             "/usr/lib/pkgconfig/:/usr/X11/lib/pkgconfig/"

    # pygtk-codegen-2.0 has been deprecated and replaced by
    # pygobject-codegen-2.0, but the vte Makefile fails to detect this.
    ENV["PYGTK_CODEGEN"] = "/usr/local/bin/pygobject-codegen-2.0"
    
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-python",
                          "--disable-Bsymbolic"
    system "make install"
  end
end
