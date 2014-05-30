require 'formula'

class Libwpg < Formula
  homepage 'http://libwpg.sourceforge.net/'
  url 'https://downloads.sourceforge.net/libwpg/libwpg-0.3.0.tar.bz2'
  sha1 'c8422f9a01e98ff3cb5d64d518e61f6a0bb77551'

  depends_on 'pkg-config' => :build
  depends_on 'libwpd'
  depends_on 'librevenge'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    # Separate steps or install can fail due to folders not existing
    system "make"
    ENV.j1
    system "make install"
  end
end
