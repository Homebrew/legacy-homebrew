class Sdl2Net < Formula
  desc "Small sample cross-platform networking library"
  homepage "http://www.libsdl.org/projects/SDL_net/"
  url "http://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.0.0.tar.gz"
  sha256 "d715be30783cc99e541626da52079e308060b21d4f7b95f0224b1d06c1faacab"

  depends_on "pkg-config" => :build
  depends_on "sdl2"

  option :universal

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL2_net.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end
end
