require 'formula'

class SdlImage < Formula
  homepage 'http://www.libsdl.org/projects/SDL_image'
  url 'http://www.libsdl.org/projects/SDL_image/release/SDL_image-1.2.12.tar.gz'
  sha1 '5e3e393d4e366638048bbb10d6a269ea3f4e4cf2'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'sdl'
  depends_on 'jpeg'    => :recommended
  depends_on 'libpng'  => :recommended
  depends_on 'libtiff' => :recommended
  depends_on 'webp'    => :recommended

  option :universal

  def install
    ENV.universal_binary if build.universal?
    inreplace 'SDL_image.pc.in', '@prefix@', HOMEBREW_PREFIX

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-sdltest"
    system "make install"
  end
end
