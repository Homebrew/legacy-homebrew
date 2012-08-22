require 'formula'

class Svg2pdf < Formula
  homepage 'http://cairographics.org/'
  url 'http://cairographics.org/snapshots/svg2pdf-0.1.3.tar.gz'
  sha1 '07c5e8b95b43bcdd40d791ccb1a2cb5221093f19'

  depends_on 'pkg-config' => :build
  depends_on 'libsvg-cairo'

  def install
    # So pkg-config can find cairo for libsvg-cairo.
    ENV.prepend 'PKG_CONFIG_PATH', "#{MacOS::X11.lib}/pkgconfig", ':'
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
