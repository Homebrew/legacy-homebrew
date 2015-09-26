class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.0.tar.gz"
  sha256 "b29815c73b17633baca9f07113e8ac476ae66412dec0d29a5045825c27a47234"

  bottle do
    cellar :any
    revision 1
    sha256 "436d19a1bad3e12700d3e5e7b792e0c0255c71c596a1f31bede76a86598ddf99" => :el_capitan
    sha1 "7a56f926c38dc00f26ca9beed5467744c6808846" => :yosemite
    sha1 "3caf4552d4f7375523ec943626b58b5b5897bea8" => :mavericks
    sha1 "39628bcec4c2a8a64ec255c6adabc55de7481678" => :mountain_lion
  end

  revision 1

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "jpeg"    => :recommended
  depends_on "libpng"  => :recommended
  depends_on "libtiff" => :recommended
  depends_on "webp"    => :recommended

  option :universal

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-imageio=no"
    system "make", "install"
  end
end
