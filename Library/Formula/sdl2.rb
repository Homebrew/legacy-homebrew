require 'formula'

class Sdl2 < Formula
  homepage 'http://www.libsdl.org/'
  url 'http://www.libsdl.org/release/SDL2-2.0.0.tar.gz'
  sha1 'a907eb5203abad6649c1eae0120d96c0a1931350'

  head do
    url 'http://hg.libsdl.org/SDL', :using => :hg

    depends_on :automake
    depends_on :libtool
  end

  option :universal

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl2.pc.in sdl2-config.in], '@prefix@', HOMEBREW_PREFIX

    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix}]
    # LLVM-based compilers choke on the assembly code packaged with SDL.
    args << '--disable-assembly' if ENV.compiler == :llvm or (ENV.compiler == :clang and MacOS.clang_build_version < 421)
    args << '--without-x'

    system './configure', *args
    system "make install"
  end

  def test
    system "#{bin}/sdl2-config", "--version"
  end
end
