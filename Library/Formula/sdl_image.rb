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
    sha256 "e83195b71168254d604d4ddce29e46fb20936aaeff552af6bc069789811fd8fb" => :yosemite
    sha256 "44c25bb021c727aae7ea25288eb1cf4513e37989d09aab1f0ab18235c79fde6b" => :mavericks
    sha256 "30d6d38faf7ac954ba52408aada73901a6d858ba97a685b635f763ac4f86c55f" => :mountain_lion
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
