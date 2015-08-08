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

  # Fix broken TTF_RenderGlyph_Shaded()
  # https://bugzilla.libsdl.org/show_bug.cgi?id=1433
  patch do
    url "https://gist.githubusercontent.com/tomyun/a8d2193b6e18218217c4/raw/8292c48e751c6a9939db89553d01445d801420dd/sdl_ttf-fix-1433.diff"
    sha256 "4c2e38bb764a23bc48ae917b3abf60afa0dc67f8700e7682901bf9b03c15be5f"
  end

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL_ttf.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest"
    system "make", "install"
  end
end
