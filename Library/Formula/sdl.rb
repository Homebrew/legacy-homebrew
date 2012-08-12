require 'formula'

class Sdl < Formula
  homepage 'http://www.libsdl.org/'
  url 'http://www.libsdl.org/release/SDL-1.2.15.tar.gz'
  md5 '9d96df8417572a2afb781a7c4c811a85'

  head 'http://hg.libsdl.org/SDL', :using => :hg

  depends_on :x11

  if build.head?
    depends_on :automake
    depends_on :libtool
  end

  option :universal

  def install
    # we have to do this because most build scripts assume that all sdl modules
    # are installed to the same prefix. Consequently SDL stuff cannot be
    # keg-only but I doubt that will be needed.
    inreplace %w[sdl.pc.in sdl-config.in], '@prefix@', HOMEBREW_PREFIX

    ENV.universal_binary if build.universal?

    system "./autogen.sh" if build.head?

    args = %W[--prefix=#{prefix}]
    args << "--disable-nasm" unless MacOS.mountain_lion? # might work with earlier, might only work with new clang
    # LLVM-based compilers choke on the assembly code packaged with SDL.
    args << '--disable-assembly' if ENV.compiler == :llvm or ENV.compiler == :clang and MacOS.clang_build_version < 421

    system './configure', *args
    system "make install"

    # Copy source files needed for Ojective-C support.
    libexec.install Dir["src/main/macosx/*"]
  end
end
