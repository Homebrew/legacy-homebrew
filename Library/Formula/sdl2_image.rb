class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.0.tar.gz"
  sha256 "b29815c73b17633baca9f07113e8ac476ae66412dec0d29a5045825c27a47234"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "436d19a1bad3e12700d3e5e7b792e0c0255c71c596a1f31bede76a86598ddf99" => :el_capitan
    sha256 "a4c4f1c81d23373b9c7a448e4c0e117a342ee201552db534b2f940af8b0a2857" => :yosemite
    sha256 "bb9bb853a1be445bf71203618dfaf92f00eb1fc64d178379115ad12eda6e0f69" => :mavericks
    sha256 "76fd7ece6082d8c1624ec28adcdeb7089676fc97554b7964628c5f8d0a3a1c97" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "jpeg"    => :recommended
  depends_on "libpng"  => :recommended
  depends_on "libtiff" => :recommended
  depends_on "webp"    => :recommended

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL2_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-imageio=no"
    system "make", "install"
  end
end
