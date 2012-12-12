require 'formula'

class Pangomm < Formula
  homepage 'http://www.pango.org/'
  url 'http://ftp.gnome.org/pub/GNOME/sources/pangomm/2.28/pangomm-2.28.4.tar.bz2'
  sha256 '933631c110e091f42d16a0f7d7d8f0249b2c762b83db9cfd9091e8fda1b772a5'

  depends_on 'pkg-config' => :build
  depends_on 'pango'
  depends_on 'glibmm'
  depends_on 'cairomm'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
