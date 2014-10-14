require 'formula'

class SdlGfx < Formula
  homepage 'http://www.ferzkopp.net/joomla/content/view/19/14/'
  url 'http://www.ferzkopp.net/Software/SDL_gfx-2.0/SDL_gfx-2.0.24.tar.gz'
  sha1 '34e8963188e4845557468a496066a8fa60d5f563'

  bottle do
    cellar :any
    sha1 "358c2bec6cdd846a198230b3c35f8d9446d7056b" => :mavericks
    sha1 "30d6561259dd7cc35b6ce51913729aedd2d766ce" => :mountain_lion
    sha1 "3af37af44834746b8ac841d88ac82cd523a5fa79" => :lion
  end

  depends_on 'sdl'

  option :universal

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make install"
  end
end
