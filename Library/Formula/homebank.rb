require 'formula'

class Homebank < Formula
  homepage 'http://homebank.free.fr'
  url 'http://homebank.free.fr/public/homebank-4.5.2.tar.gz'
  sha1 'a9caa11edfd15f4dbe2e2957a11026d0b71aea24'

  depends_on 'pkg-config' => :build
  depends_on 'intltool' => :build
  depends_on 'gettext'
  depends_on 'gtk+'
  depends_on 'hicolor-icon-theme'
  depends_on :freetype
  depends_on :fontconfig

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "chmod +x ./install-sh"
    system "make install"
  end
end
