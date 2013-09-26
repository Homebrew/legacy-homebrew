require 'formula'

class AtSpi2Atk < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.10/at-spi2-atk-2.10.0.tar.xz'
  sha256 'dea7ff2f9bc9bbdb0351112616d738de718b55739cd2511afecac51604c31a94'

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
