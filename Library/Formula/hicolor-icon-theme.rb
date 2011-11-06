require 'formula'

class HicolorIconTheme < Formula
  url 'http://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.12.tar.gz'
  homepage 'http://icon-theme.freedesktop.org/wiki/HicolorTheme'
  md5 '55cafbcef8bcf7107f6d502149eb4d87'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
