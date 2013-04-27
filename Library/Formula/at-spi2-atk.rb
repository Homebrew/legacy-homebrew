require 'formula'

class AtSpi2Atk < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.8/at-spi2-atk-2.8.1.tar.xz'
  sha256 'eb659b94fde6dc0a2f584c9121a5e6d39a4c8aa297d21d8f9032f7a8a775fd06'

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
