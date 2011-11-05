require 'formula'

class Dia < Formula
  url 'http://ftp.gnome.org/pub/gnome/sources/dia/0.97/dia-0.97.1.tar.bz2'
  homepage 'http://live.gnome.org/Dia'
  sha256 '8dfe8b2c9d87baf29834c8de5e3ec91497c2b17f2b77fb1b867afddf5c429142'

  depends_on 'pkg-config' => :build
  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'pango'
  depends_on 'libtiff'
  depends_on 'gtk+'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
    rm_rf share+"applications"
  end
end
