require 'formula'

class Glade < Formula
  homepage 'http://glade.gnome.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glade3/3.8/glade3-3.8.4.tar.xz'
  sha256 'c7ae0775b96a400cf43be738b2f836663a505b1458255df9ce83a340057e3d08'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'libglade'
  depends_on 'libxml2'
  depends_on 'hicolor-icon-theme'
  depends_on :x11

  def install
    # Find our docbook catalog
    ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make" # separate steps required
    system "make", "install"
  end
end
