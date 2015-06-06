require 'formula'

class Sdl2Gfx < Formula
  desc "SDL2 graphics drawing primitives and other support functions"
  homepage 'http://www.ferzkopp.net/joomla/content/view/19/14/'
  url 'http://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.0.0.tar.gz'
  sha1 '6b83f57a62a3d2a3850a56902a008d801c799ff8'

  depends_on 'sdl2'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make install"
  end
end
