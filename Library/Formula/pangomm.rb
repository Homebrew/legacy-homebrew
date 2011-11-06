require 'formula'

class Pangomm < Formula
  url 'http://ftp.gnome.org/pub/GNOME/sources/pangomm/2.26/pangomm-2.26.2.tar.gz'
  homepage 'http://www.pango.org/'
  md5 '2ccc1a5e271d90d4d1a414e0e234329a'

  depends_on 'pkg-config' => :build
  depends_on 'pango'
  depends_on 'glibmm'
  depends_on 'cairomm'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
