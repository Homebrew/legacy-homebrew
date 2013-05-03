require 'formula'

class Glade < Formula
  homepage 'http://glade.gnome.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glade3/3.8/glade3-3.8.3.tar.xz'
  sha256 '84bb2d7f782f203e4aab923e47db8d22529229b13e59570945261611c63941d6'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'libglade'
  depends_on 'hicolor-icon-theme'
  depends_on :x11

  def install
    pydir = 'python' + `python -c 'import sys;print(sys.version[:3])'`.strip
    libxml2 = Formula.factory('libxml2')
    ENV.prepend 'PYTHONPATH', libxml2.lib/pydir/'site-packages', ':'

    # Find our docbook catalog
    ENV['XML_CATALOG_FILES'] = "#{etc}/xml/catalog"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make" # separate steps required
    system "make", "install"
  end
end
