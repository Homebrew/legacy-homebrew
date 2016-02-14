class Sdl2Image < Formula
  desc "Library for loading images as SDL surfaces and textures"
  homepage "https://www.libsdl.org/projects/SDL_image/"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.1.tar.gz"
  sha256 "3a3eafbceea5125c04be585373bfd8b3a18f259bd7eae3efc4e6d8e60e0d7f64"
  revision 1

  bottle do
    cellar :any
    sha256 "8ffdcc75d5e300da37890307580a38f1e7393fee7e3053e13dcf1e16d153fea6" => :el_capitan
    sha256 "2fb42da2d5d39a90be7d28089f92527a405618c23da638c84121850b3ee766be" => :yosemite
    sha256 "8e5a4437ddccffe5dada2e19aa3cbdf8d857f00df793b3456f0356115e4082af" => :mavericks
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
