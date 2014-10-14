require "formula"

class SdlTtf < Formula
  homepage "http://www.libsdl.org/projects/SDL_ttf/"
  url "http://www.libsdl.org/projects/SDL_ttf/release/SDL_ttf-2.0.11.tar.gz"
  sha1 "0ccf7c70e26b7801d83f4847766e09f09db15cc6"

  bottle do
    cellar :any
    sha1 "3876dd0927050f70f7d5b5658938c3780c34f44b" => :mavericks
    sha1 "9427a99c35761cba9e585f00b797800fb0497e19" => :mountain_lion
    sha1 "7822774b7bce3812a374d568ca5101d33cc75047" => :lion
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
