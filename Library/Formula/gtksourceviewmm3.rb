require 'formula'

class Gtksourceviewmm3 < Formula
  homepage 'https://developer.gnome.org/gtksourceviewmm/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtksourceviewmm/3.2/gtksourceviewmm-3.2.0.tar.xz'
  sha1 'cac8d2fdde7b862bdb5eb12c6b8998a29e3fcf95'

  depends_on 'gtksourceview3'
  depends_on 'pkg-config' => :build
  depends_on 'gtkmm3'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
