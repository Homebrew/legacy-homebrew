class Sdl2Net < Formula
  desc "Small sample cross-platform networking library"
  homepage "https://www.libsdl.org/projects/SDL_net/"
  url "https://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.0.0.tar.gz"
  sha256 "d715be30783cc99e541626da52079e308060b21d4f7b95f0224b1d06c1faacab"

  bottle do
    cellar :any
    sha256 "a2cb7b9d8e656c3c307a9b5384912da665b9c7edace584e97d82c229cb64a7f0" => :el_capitan
    sha256 "0f84b5c2cfa26b3af60c05eb137b5f0fb1aaccc1ccae35cb6d724599db1204b2" => :yosemite
    sha256 "b1177a6c6c2836e2f5dd574c17efe61df837dddbac1aa6d1b266f8b892faec36" => :mavericks
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
