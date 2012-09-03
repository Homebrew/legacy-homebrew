require 'formula'

class Homebank < Formula
  url 'http://homebank.free.fr/public/homebank-4.4.tar.gz'
  homepage 'http://homebank.free.fr'
  sha1 '78b97c0ff118e21a1e0dd1935473601c2b7924a6'

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
