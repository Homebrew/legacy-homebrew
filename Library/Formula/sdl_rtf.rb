class SdlRtf < Formula
  desc "Sample library to display Rich Text Format (RTF) documents"
  homepage "https://www.libsdl.org/projects/SDL_rtf/"
  url "https://www.libsdl.org/projects/SDL_rtf/release/SDL_rtf-0.1.0.tar.gz"
  sha256 "3dc0274b666e28010908ced24844ca7d279e07b66f673c990d530d4ea94b757e"

  bottle do
    cellar :any
    sha256 "6c7e9f7459ff062fbb48ee1a383a4fd4acc2c29f5ee9b57dea93710c94ccda11" => :el_capitan
    sha256 "8dd89df32c9ea02bcab36932c2f22bcb6de58d6002bd6fb9e95f9bbfe5ccf41e" => :yosemite
    sha256 "9d077d10fc0102738e3c7d445cf2c8290150f98b4fb92e1b72bb3e5857dc3b3e" => :mavericks
  end

  head "https://hg.libsdl.org/SDL_rtf", :using => :hg

  depends_on "sdl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
