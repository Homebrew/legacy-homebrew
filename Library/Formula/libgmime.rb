require 'formula'

class Libgmime < Formula
  url 'http://ftp.acc.umu.se/pub/GNOME/sources/gmime/2.6/gmime-2.6.13.tar.xz'
  homepage 'http://spruce.sourceforge.net/gmime/'
  sha256 '42a47a7f9508db3e1cfbb374a23260e75d7fc7696f488a26aa59f5e2d8dac154'

  depends_on 'xz' => :build

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
