class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.1.tar.gz"
  sha256 "3a3eafbceea5125c04be585373bfd8b3a18f259bd7eae3efc4e6d8e60e0d7f64"

  bottle do
    cellar :any
    revision 2
    sha256 "2889b8332feb1684d474b9f7b3a18b776500d92641c6f136a8a6585bcbd083fa" => :el_capitan
    sha256 "3b94e3c8aa7ae44c5dce4204adcb4d1a240c4a119cc16f40dadb49ddd0ebe61d" => :yosemite
    sha256 "011f2227503c09a600fc715ebde104446568b67f8cdc38e8b971f31857e86e0d" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "jpeg" => :recommended
  depends_on "libpng" => :recommended
  depends_on "libtiff" => :recommended
  depends_on "webp" => :recommended

  def install
    ENV.universal_binary if build.universal?

    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-imageio=no"
    system "make", "install"
  end
end
