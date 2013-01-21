require 'formula'

class GtkDoc < Formula
  homepage 'http://www.gtk.org/gtk-doc/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtk-doc/1.18/gtk-doc-1.18.tar.bz2'
  sha256 'a634d2e93d70468237033c06a17c97f29cf71a35ac5cc01c016324c965d42f73'

  depends_on 'pkg-config' => :build
  depends_on 'gnome-doc-utils' => :build
  depends_on :python
  depends_on 'gettext'
  depends_on 'glib'
  depends_on 'docbook'
  depends_on 'docbook-xsl'
  depends_on 'libxml2'

  def install
    # libxml2 is keg_only but we installed the python bindings globally, so
    # configure should find them.
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-scrollkeeper",
                          "--with-xml-catalog=#{etc}/xml/catalog"
    system "make"
    system "make install"
  end
end
