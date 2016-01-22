class Sdl2Ttf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.13.tar.gz"
  sha256 "25ddad0302e7d74ce16a770974930cefbdcf67499ca7d40ce7a6bd7de6022fdf"

  bottle do
    cellar :any
    sha256 "cdc88dffd18a0875a1b2bb65082c8b4b457999c42a4f48352c2b40169e47d7a1" => :el_capitan
    sha256 "d37c41ba21a809c7d60eb8779309fdde625a7e9b81b9fad34d17d2dbc90e6e28" => :yosemite
    sha256 "bfddff4953dc3761a5e0379b6761bec7cdd6a7c90ea2b8e9e37a00009e586334" => :mavericks
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
