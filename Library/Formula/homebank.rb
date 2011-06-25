require 'formula'

class Homebank < Formula
  url 'http://homebank.free.fr/public/homebank-4.4.tar.gz'
  homepage 'http://homebank.free.fr'
  md5 '840ef7f2425207d9c03e1694cf4d3a0d'

  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'hicolor-icon-theme'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "chmod +x ./install-sh"
    system "make install"
  end
end
