require 'formula'

class AtSpi2Atk < Formula
  homepage 'http://a11y.org'
  url 'http://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.12/at-spi2-atk-2.12.0.tar.xz'
  sha256 '3b5467c9f169812bc36a4245355b7deedea0a62eb22153df96ced88dcd1c3633'

  depends_on 'pkg-config' => :build
  depends_on 'at-spi2-core'
  depends_on 'atk'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
