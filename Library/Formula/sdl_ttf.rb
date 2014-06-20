require "formula"

class SdlTtf < Formula
  homepage "http://www.libsdl.org/projects/SDL_ttf/"
  url "http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz"
  sha1 "0ccf7c70e26b7801d83f4847766e09f09db15cc6"

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "freetype"

  def install
    ENV.universal_binary if build.universal?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
