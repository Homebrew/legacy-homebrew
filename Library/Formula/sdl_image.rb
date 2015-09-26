class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://www.libsdl.org/projects/SDL_image"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
  sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "344d65182a61e9fa75180773f9cf706ff5d190777c6535abfbacd5965ac1ca0c" => :el_capitan
    sha1 "8748809171bc755a7e359d6b229a1803eba5a3a8" => :yosemite
    sha1 "f9d44a7ab0a8b97ff542f6b005cdc2d57a41884a" => :mavericks
    sha1 "92e68a5f6681dfc0f884dfea752804c3876bf9d5" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "sdl"
  depends_on "jpeg"    => :recommended
  depends_on "libpng"  => :recommended
  depends_on "libtiff" => :recommended
  depends_on "webp"    => :recommended

  option :universal

  def install
    ENV.universal_binary if build.universal?
    inreplace "SDL_image.pc.in", "@prefix@", HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-sdltest"
    system "make", "install"
  end
end
