require 'formula'

class Writerperfect < Formula
  homepage 'http://libwpd.sourceforge.net/'
  url 'https://downloads.sourceforge.net/libwpd/writerperfect-0.8.1.tar.bz2'
  sha1 'c48b42f042973923f56d17ce4c1b5024b6e6dcb8'

  depends_on 'pkg-config' => :build
  depends_on "libwpg"
  depends_on "libwpd"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
