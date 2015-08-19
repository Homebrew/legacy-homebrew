class SdlNet < Formula
  desc "Sample cross-platform networking library"
  homepage "http://www.libsdl.org/projects/SDL_net/"
  url "http://www.libsdl.org/projects/SDL_net/release/SDL_net-1.2.8.tar.gz"
  sha256 "5f4a7a8bb884f793c278ac3f3713be41980c5eedccecff0260411347714facb4"

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl"

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
