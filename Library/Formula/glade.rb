require 'formula'

class Glade < Formula
  homepage 'http://glade.gnome.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/glade3/3.8/glade3-3.8.5.tar.xz'
  sha256 '58a5f6e4df4028230ddecc74c564808b7ec4471b1925058e29304f778b6b2735'

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
