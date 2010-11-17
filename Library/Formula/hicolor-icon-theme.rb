require 'formula'

class HicolorIconTheme <Formula
  url 'http://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.12.tar.gz'
  homepage 'http://freedesktop.org/wiki/Software/icon-theme'
  md5 '947c7f6eb68fd95c7b86e87f853ceaa0'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
