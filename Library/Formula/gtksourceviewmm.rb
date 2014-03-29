require 'formula'

class Gtksourceviewmm < Formula
  homepage 'https://developer.gnome.org/gtksourceviewmm/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/gtksourceviewmm/2.10/gtksourceviewmm-2.10.3.tar.xz'
  sha1 '17d5daf33d2b6bc21c48c5c730abaae70e027566'

  depends_on 'gtksourceview'
  depends_on 'pkg-config' => :build
  depends_on 'gtkmm'
  depends_on :x11

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
