class Sdl2Net < Formula
  desc "Small sample cross-platform networking library"
  homepage "https://www.libsdl.org/projects/SDL_net/"
  url "https://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.0.1.tar.gz"
  sha256 "15ce8a7e5a23dafe8177c8df6e6c79b6749a03fff1e8196742d3571657609d21"

  bottle do
    cellar :any
    revision 1
    sha256 "0cacd3c585011d400bca056c9066775716c742c8dc11a2dff9ff5853d6443e7f" => :el_capitan
    sha256 "251f8d47a039fbf6c3d78800c9678a114e3795402ff2712b12c34cd4773aa2f0" => :yosemite
    sha256 "1977669f81a83dfcb00c55d79f7cfbdefae1d5fdbe8ce814a0497b516e83084e" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl2"

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL2_net.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--disable-sdltest"
    system "make", "install"
  end
end
