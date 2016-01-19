class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.1.tar.gz"
  sha256 "3a3eafbceea5125c04be585373bfd8b3a18f259bd7eae3efc4e6d8e60e0d7f64"

  bottle do
    cellar :any
    sha256 "dee664ee71b691ae0afa8aacfb041996e264f8219eea63ca2e94072c76fbc318" => :el_capitan
    sha256 "751f20138c88a1ce344577f3533cc2427275d4cc373b64233045e0dad20d082f" => :yosemite
    sha256 "622826a76aecb7d19d2c9a946e621a9aab3591b144a30725425ee8c8565f3f52" => :mavericks
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
