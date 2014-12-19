require 'formula'

class Sdl2Image < Formula
  homepage 'http://www.libsdl.org/projects/SDL_image/'
  url 'http://www.libsdl.org/projects/SDL_image/release/SDL2_image-2.0.0.tar.gz'
  sha1 '20b1b0db9dd540d6d5e40c7da8a39c6a81248865'

  bottle do
    cellar :any
    revision 1
    sha1 "7a56f926c38dc00f26ca9beed5467744c6808846" => :yosemite
    sha1 "3caf4552d4f7375523ec943626b58b5b5897bea8" => :mavericks
    sha1 "39628bcec4c2a8a64ec255c6adabc55de7481678" => :mountain_lion
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
