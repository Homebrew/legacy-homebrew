require 'formula'

class Homebank <Formula
  url 'http://homebank.free.fr/public/homebank-4.3.tar.gz'
  homepage 'http://homebank.free.fr'
  md5 '1a5d51c8c1233e0f707f6190636bc8a2'

  depends_on 'intltool'
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'hicolor-icon-theme'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "chmod +x ./install-sh"
    system "make install"
  end
end
