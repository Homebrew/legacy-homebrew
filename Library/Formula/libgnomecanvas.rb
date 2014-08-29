require 'formula'

class Libgnomecanvas < Formula
  homepage 'http://developer.gnome.org/libgnomecanvas/2.30/'
  url 'http://ftp.gnome.org/pub/gnome/sources/libgnomecanvas/2.30/libgnomecanvas-2.30.3.tar.bz2'
  sha256 '859b78e08489fce4d5c15c676fec1cd79782f115f516e8ad8bed6abcb8dedd40'

  bottle do
    cellar :any
    sha1 "8f780d6f8ac023d7c95ab9ed840ef9a3e744930d" => :mavericks
    sha1 "48a0f4f0e3992af6585e4093e4e7b1aafcae8cfc" => :mountain_lion
    sha1 "178631caf4c0959cf69e386e4cc91640a8471e21" => :lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'libglade'
  depends_on 'libart'
  depends_on 'gettext'
  depends_on 'gtk+'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-static",
                          "--prefix=#{prefix}",
                          "--enable-glade"
    system "make install"
  end
end
