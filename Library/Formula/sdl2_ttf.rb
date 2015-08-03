class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "http://www.libsdl.org/projects/SDL_ttf/"
  url "http://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.12.tar.gz"
  sha256 "8728605443ea1cca5cad501dc34dc0cb15135d1e575551da6d151d213d356f6e"

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "freetype"

  option :universal

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
