require 'formula'

class AtSpi2Atk < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.8/at-spi2-atk-2.8.0.tar.xz'
  sha256 '4688acbc1474cda0aa49341f109ad0726603ce3e872cc6521c74931338c7ba20'

  depends_on 'pkg-config' => :build
  depends_on 'xz' => :build
  depends_on 'at-spi2-core'
  depends_on 'atk'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
