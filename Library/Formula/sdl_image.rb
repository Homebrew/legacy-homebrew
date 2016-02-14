class SdlImage < Formula
  desc "Image file loading library"
  homepage "https://www.libsdl.org/projects/SDL_image"
  url "https://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz"
  sha256 "0b90722984561004de84847744d566809dbb9daf732a9e503b91a1b5a84e5699"
  revision 2

  bottle do
    cellar :any
    sha256 "e2c29e2f54c49c4334e6c5315a89e134256716dbb01bbfb2c67b0354a8dca756" => :el_capitan
    sha256 "b110f8bee989e5c2f33cc1cc180fb1c56b0ea9b11fe2f08a2db9911367c799d6" => :yosemite
    sha256 "84272135304e7c475e8000a90af113127858273a4449ce6566805f5b4c2cb476" => :mavericks
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
