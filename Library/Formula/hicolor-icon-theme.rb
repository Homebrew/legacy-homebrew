require 'formula'

class HicolorIconTheme < Formula
  homepage 'http://icon-theme.freedesktop.org/wiki/HicolorTheme'
  url 'http://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.13.tar.gz'
  sha1 '15e30dfcf5e7b53c1a6f9028c30665006abba55c'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
