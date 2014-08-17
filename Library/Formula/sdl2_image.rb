require 'formula'

class Sdl2Image < Formula
  homepage 'http://www.libsdl.org/projects/SDL_image/'
  url 'http://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.0.tar.gz'
  sha1 '20b1b0db9dd540d6d5e40c7da8a39c6a81248865'

  bottle do
    cellar :any
    sha1 "69d3d89b748dc8663a0b63cb837cdfd6a9906b1e" => :mavericks
    sha1 "8076555e8cc46fbc3295024b0da3c6b55ce7fef3" => :mountain_lion
    sha1 "ec7d9701b970b10c06073133fd75c498d8b201e1" => :lion
  end

  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'sdl2'
  depends_on 'jpeg'    => :recommended
  depends_on 'libpng'  => :recommended
  depends_on 'libtiff' => :recommended
  depends_on 'webp'    => :recommended

  option :universal

  def install
    ENV.universal_binary if build.universal?
    inreplace 'SDL2_image.pc.in', '@prefix@', HOMEBREW_PREFIX

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-imageio=no"
    system "make", "install"
  end
end
