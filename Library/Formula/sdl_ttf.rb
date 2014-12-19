require "formula"

class SdlTtf < Formula
  homepage "http://www.libsdl.org/projects/SDL_ttf/"
  url "http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz"
  sha1 "0ccf7c70e26b7801d83f4847766e09f09db15cc6"

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
