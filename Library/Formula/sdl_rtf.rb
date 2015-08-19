class SdlRtf < Formula
  desc "Sample library to display Rich Text Format (RTF) documents"
  homepage "http://www.libsdl.org/projects/SDL_rtf/"
  url "http://www.libsdl.org/projects/SDL_rtf/release/SDL_rtf-0.1.0.tar.gz"
  sha256 "3dc0274b666e28010908ced24844ca7d279e07b66f673c990d530d4ea94b757e"

  head "http://hg.libsdl.org/SDL_rtf", :using => :hg

  depends_on "sdl"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
