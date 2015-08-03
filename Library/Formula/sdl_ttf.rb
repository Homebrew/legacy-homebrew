class SdlTtf < Formula
  desc "Library for using TrueType fonts in SDL applications"
  homepage "https://www.libsdl.org/projects/SDL_ttf/"
  url "https://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz"
  sha256 "724cd895ecf4da319a3ef164892b72078bd92632a5d812111261cde248ebcdb7"

  bottle do
    cellar :any
    revision 1
    sha1 "ef450cac430fb2f581f0b93d3c44b941828e96eb" => :yosemite
    sha1 "b312c46ace8fca0219dacda256077051d6c2e666" => :mavericks
    sha1 "6df57f99f03a918b88b007d8b1698e3485faf3c6" => :mountain_lion
  end

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
