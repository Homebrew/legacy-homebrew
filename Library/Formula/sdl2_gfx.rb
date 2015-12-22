class Sdl2Gfx < Formula
  desc "SDL2 graphics drawing primitives and other support functions"
  homepage "http://cms.ferzkopp.net/index.php/software/13-sdl-gfx"
  url "http://www.ferzkopp.net/Software/SDL2_gfx/SDL2_gfx-1.0.1.tar.gz"
  sha256 "d69bcbceb811b4e5712fbad3ede737166327f44b727f1388c32581dbbe8c599a"

  option :universal

  depends_on "sdl2"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
