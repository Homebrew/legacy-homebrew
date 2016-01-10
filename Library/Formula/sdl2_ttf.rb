class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.12.tar.gz"
  sha256 "8728605443ea1cca5cad501dc34dc0cb15135d1e575551da6d151d213d356f6e"

  bottle do
    cellar :any
    sha256 "7ab0f82c53576616dea7c90bb13a43e77a7983d91688aacecbc24afccce97a22" => :el_capitan
    sha256 "60887468da9d0953535711bd5d3ada6c0164ef564eee4fd3c12dfb33ab863905" => :yosemite
    sha256 "81b146fbe2a5dfdc81770a728224f37ef85a7c24e6e39b5d881ef1e2e20cae31" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "freetype"

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL2_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
