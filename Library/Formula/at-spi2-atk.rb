require 'formula'

class AtSpi2Atk < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.10/at-spi2-atk-2.10.2.tar.xz'
  sha256 'e348a811c4830251f0c3018019072e7979ef35fb9b7f0b1b0a0dd1e66942d0f5'

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
